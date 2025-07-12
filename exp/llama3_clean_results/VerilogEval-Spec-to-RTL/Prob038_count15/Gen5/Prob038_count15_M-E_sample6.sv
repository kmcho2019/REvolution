module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else begin
        // Using an LFSR with a polynomial x^4 + x + 1 to generate a sequence
        // with a period of 16
        q <= {q[2:0], q[3] ^ q[0]};
    end
end

endmodule