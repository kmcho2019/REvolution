module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] gray_count;
reg [9:0] next_gray_count;

always @(posedge clk) begin
    if (reset) begin
        gray_count <= 10'd0;
    end else begin
        gray_count <= next_gray_count;
    end
end

assign next_gray_count = (gray_count == 10'd999)? 10'd0 : gray_count + 10'd1;

assign q = gray_count;

endmodule