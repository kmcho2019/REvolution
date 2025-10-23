module TopModule(
    input  clk,
    input  reset,
    output [9:0] q
);

reg [9:0] lfsr;

always @(posedge clk) begin
    if (reset) begin
        lfsr <= 10'd1; // Initial condition for the LFSR sequence
    end else begin
        // LFSR with polynomial x^10 + x^7 + 1 ( primitive polynomial for 10-bit sequence)
        lfsr <= {lfsr[8:0], lfsr[9] ^ lfsr[6]};
    end
end

// Since the LFSR sequence starts from 1 and goes up to 1023, 
// we need to adjust the output to match the required counting sequence
assign q = (lfsr > 10'd999) ? 10'd0 : lfsr;

endmodule