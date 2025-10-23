module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] count;
reg [9:0] next_count;

always @(*) begin
    if (reset) begin
        next_count = 10'd0;
    end else begin
        next_count = (count == 10'd999)? 10'd0 : count + 10'd1;
    end
end

always @(posedge clk) begin
    count <= next_count;
end

assign q = count;

endmodule