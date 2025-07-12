module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] count;
reg [9:0] next_count;

always @(posedge clk) begin
    if (reset) begin
        count <= 10'd0;
    end else begin
        count <= next_count;
    end
end

assign next_count = (count == 10'd999) ? 10'd0 : count + 10'd1;

assign q = count;

endmodule