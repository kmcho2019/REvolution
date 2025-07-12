module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;
wire [3:0] next_count;

assign next_count = (count == 4'd9) ? 4'd0 : count + 1'b1;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0;
    end else begin
        count <= next_count;
    end
end

assign q = count;

endmodule