module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// synthesis attribute async_reg of Q is true;  // Helps with timing closure

always @(posedge clk or negedge rst_n)
    if (!rst_n) Q <= 64'b0;           // Active-low reset clears counter
    else Q <= Q[0] ? {1'b0, Q[63:1]}  // Count down when LSB=1
                   : {1'b1, Q[63:1]}; // Count up when LSB=0
    // Note: Could add clock gating when stable (all 1s/0s) for power optimization

endmodule