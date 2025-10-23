module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    reg [1:0] state;  // [0] = A, [1] = B
    
    // Clock gating control
    wire clk_en = (state[0] & ~in) | (state[1] & in) | areset;
    wire gated_clk = clk & clk_en;
    
    // Next state logic (simplified)
    always @(posedge gated_clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // Reset to state B
        end
        else begin
            state[0] <= ~in & state[1];  // A state transition
            state[1] <= in | state[0];   // B state transition
        end
    end
    
    // Output is simply the B state bit
    assign out = state[1];
    
endmodule