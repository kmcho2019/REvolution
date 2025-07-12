module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] lfsr;

always @(posedge clk) begin
    if (reset) begin
        lfsr <= 10'd1; // Initialize LFSR with a non-zero value
    end else begin
        lfsr <= {lfsr[8:0], lfsr[9] ^ lfsr[8]}; // LFSR with polynomial x^10 + x^9 + 1
    end
end

assign q = lfsr - 10'd1; // Adjust output to count from 0 to 999

endmodule