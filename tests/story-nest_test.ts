import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Can create a new story",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall(
        "story-nest",
        "create-story",
        [
          types.utf8("Test Story"),
          types.utf8("Story content here"),
          types.utf8("{}")
        ],
        wallet_1.address
      )
    ]);
    
    assertEquals(block.receipts.length, 1);
    assertEquals(block.height, 2);
    block.receipts[0].result.expectOk().expectUint(1);
  },
});

Clarinet.test({
  name: "Can like and comment on stories",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    // Test implementation
  },
});

Clarinet.test({ 
  name: "Can follow other users",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    // Test implementation
  },
});
