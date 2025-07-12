module JC_counter (
    input  wire       clk,    // Clock input
    input  wire       rst_n,  // Active-low synchronous reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

always @(posedge clk) begin
    if (!rst_n)
        Q <= 64'b0;                // Synchronous reset counter to zero
    else
        Q <= {~Q[0], Q[63:1]};    // Shift right and insert inverted LSB at MSB
end

endmodule