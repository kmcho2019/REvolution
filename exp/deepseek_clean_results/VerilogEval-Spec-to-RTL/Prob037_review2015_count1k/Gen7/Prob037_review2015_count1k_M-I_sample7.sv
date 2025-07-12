module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] count;
wire tc = (count == 10'd999);  // Terminal count signal

always @(posedge clk) begin
    if (reset) count <= 10'd0;
    else count <= tc ? 10'd0 : count + 1'b1;
end

// Binary to Gray code conversion for output
assign q = count ^ (count >> 1);

endmodule