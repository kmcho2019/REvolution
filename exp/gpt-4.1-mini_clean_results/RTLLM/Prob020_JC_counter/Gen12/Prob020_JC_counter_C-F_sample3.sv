module JC_counter (
    input  wire       clk,    // Clock input
    input  wire       rst_n,  // Active-low asynchronous reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

// Sequential logic for Johnson counter
// On reset, clear Q to 0
// Otherwise, shift Q right by one and insert inverted LSB at MSB
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'b0;             // Asynchronous reset to zero
    else
        Q <= {~Q[0], Q[63:1]}; // Johnson counter update
end

endmodule