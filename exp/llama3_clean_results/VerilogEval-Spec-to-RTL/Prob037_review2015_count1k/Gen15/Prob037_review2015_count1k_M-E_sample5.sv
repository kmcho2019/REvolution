module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] gray_count;
reg [9:0] binary_count;

always @(posedge clk) begin
    if (reset) begin
        gray_count <= 10'd0;
    end else if (gray_count == 10'd999) begin
        gray_count <= 10'd0;
    end else begin
        gray_count <= gray_count + 1;
    end
end

// Gray to Binary conversion
assign binary_count[0] = gray_count[0];
assign binary_count[1] = gray_count[1] ^ gray_count[0];
assign binary_count[2] = gray_count[2] ^ gray_count[1];
assign binary_count[3] = gray_count[3] ^ gray_count[2];
assign binary_count[4] = gray_count[4] ^ gray_count[3];
assign binary_count[5] = gray_count[5] ^ gray_count[4];
assign binary_count[6] = gray_count[6] ^ gray_count[5];
assign binary_count[7] = gray_count[7] ^ gray_count[6];
assign binary_count[8] = gray_count[8] ^ gray_count[7];
assign binary_count[9] = gray_count[9] ^ gray_count[8];

assign q = binary_count;

endmodule