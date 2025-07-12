module TopModule(
    input  clk,
    input  reset,
    output [9:0] q
);

reg [9:0] gray_count;
reg [9:0] bin_count;

always @(posedge clk) begin
    if (reset) begin
        bin_count <= 10'd0;
    end else if (bin_count == 10'd999) begin
        bin_count <= 10'd0;
    end else begin
        bin_count <= bin_count + 10'd1;
    end
end

// Gray code converter
assign gray_count = (bin_count ^ (bin_count >> 1));

// Output q is the binary count
assign q = bin_count;

endmodule