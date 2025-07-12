module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Johnson counter with 128-state cycle (2*64)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low reset clears all bits
    end else begin
        // Standard Johnson counter operation:
        // - When Q[0]==0: shift right and set MSB to 1 (counting up)
        // - When Q[0]==1: shift right and set MSB to 0 (counting down)
        Q <= Q[0] ? {1'b0, Q[63:1]} : {1'b1, Q[63:1]};
        
        // Note: For power optimization, could add:
        // if (Q == 64'hFFFFFFFFFFFFFFFF || Q == 64'h0)
        //     enable_clock_gating();
    end
end

endmodule