module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

initial q = 8'b0;

wire [7:0] shifted_in;
assign shifted_in = {d, q[7:1]};

always @(posedge clk) begin
    q <= shifted_in;
end

endmodule