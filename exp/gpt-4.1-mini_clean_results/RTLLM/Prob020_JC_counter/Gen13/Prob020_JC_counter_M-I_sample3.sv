module JC_counter (
    input  wire       clk,    // Clock input
    input  wire       rst_n,  // Active-low synchronous reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

// Sequential logic for Johnson counter
// On synchronous reset (rst_n low at clock edge), clear Q to 0
// Otherwise, shift Q right by one and insert inverted LSB at MSB
always @(posedge clk) begin
    if (!rst_n)
        Q <= 64'b0;             // Synchronous reset to zero
    else
        Q <= {~Q[0], Q[63:1]}; // Johnson counter update
end

endmodule