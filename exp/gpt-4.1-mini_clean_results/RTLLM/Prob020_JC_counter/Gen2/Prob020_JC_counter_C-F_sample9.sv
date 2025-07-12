module JC_counter (
    input  wire        clk,    // Clock signal
    input  wire        rst_n,  // Active-low asynchronous reset
    output reg  [63:0] Q       // 64-bit Johnson counter output
);

// On reset, clear Q to zero.
// On each rising edge of clk, shift right and insert inverted LSB at MSB.
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'b0;
    else
        Q <= {~Q[0], Q[63:1]};
end

endmodule