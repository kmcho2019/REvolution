module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] count;

always_ff @(posedge clk) begin
    if (reset) count <= 10'd0;
    else count <= (count == 10'd999) ? 10'd0 : (count + 10'd1);
end

assign q = count;

endmodule