module JC_counter (
    input  wire       clk,    // Clock input
    input  wire       rst_n,  // Active-low asynchronous reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Asynchronously reset to zero on reset asserted (active low)
    end else begin
        // Johnson counter update:
        // Shift register Q shifts right by one bit,
        // Insert inverted current LSB (Q[0]) into MSB,
        // producing a torsional ring counting sequence.
        Q <= { ~Q[0], Q[63:1] };
    end
end

endmodule