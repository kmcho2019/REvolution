module JC_counter (
    input  wire       clk,    // Clock signal for synchronous operation
    input  wire       rst_n,  // Asynchronous active-low reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

// Invert the least significant bit of Q for next MSB insertion
wire new_msb = ~Q[0];

// Sequential logic for Johnson counter with asynchronous reset
// On reset (active low), counter is cleared to zero immediately.
// Otherwise, on rising clock edge, shift right by 1 and insert inverted LSB at MSB.
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;               // Asynchronously reset to 0
    end else begin
        Q <= {new_msb, Q[63:1]}; // Shift right + insert inverted LSB at MSB
    end
end

endmodule