module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;
wire [3:0] next_count;

assign next_count = (reset || count == 4'd9) ? 4'b0000 : count + 1'b1;

always @ (posedge clk) begin
    count <= next_count;
end

assign q = count;

endmodule