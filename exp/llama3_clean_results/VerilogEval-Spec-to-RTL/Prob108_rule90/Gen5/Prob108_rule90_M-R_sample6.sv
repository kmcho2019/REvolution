module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;
wire [511:0] next_state;

assign next_state = ({1'b0, q_reg[511:1]}) ^ ({q_reg[510:0], 1'b0});
assign q = q_reg;

always @(posedge clk) begin
    q_reg = load? data : next_state;
end

endmodule