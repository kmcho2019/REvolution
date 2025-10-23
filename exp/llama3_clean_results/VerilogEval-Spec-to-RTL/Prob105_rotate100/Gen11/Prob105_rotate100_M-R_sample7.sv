module TopModule(
    input               clk,
    input               load,
    input      [1:0]    ena,
    input      [99:0]   data,
    output reg [99:0]   q
);

reg [99:0] q_reg;

wire [99:0] q_next_rotate_right = {q_reg[0], q_reg[99:1]};
wire [99:0] q_next_rotate_left = {q_reg[98:0], q_reg[99]};
wire [99:0] q_next_load = data;
wire [99:0] q_next_no_rotate = q_reg;

reg [99:0] q_next;

assign q_next = (load)? q_next_load :
               (ena == 2'b01)? q_next_rotate_right :
               (ena == 2'b10)? q_next_rotate_left :
               q_next_no_rotate;

always @(posedge clk) begin
    q_reg <= q_next;
end

assign q = q_reg;

endmodule