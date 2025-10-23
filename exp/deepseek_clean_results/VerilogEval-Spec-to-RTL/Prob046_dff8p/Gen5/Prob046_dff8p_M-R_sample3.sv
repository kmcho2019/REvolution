module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

localparam RESET_VAL = 8'h34;
reg [7:0] q_reg;

wire [7:0] next_q = reset ? RESET_VAL : d;

always @(negedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule