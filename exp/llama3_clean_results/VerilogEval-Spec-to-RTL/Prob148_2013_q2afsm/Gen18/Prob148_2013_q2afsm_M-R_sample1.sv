module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

parameter STATE_A = 3'b000;
parameter STATE_B = 3'b001;
parameter STATE_C = 3'b010;
parameter STATE_D = 3'b011;

reg [2:0] state;
reg [2:0] next_state;

// Compute next state using priority encoder logic
assign next_state = (r[0]) ? STATE_B :
                    (r[1]) ? STATE_C :
                    (r[2]) ? STATE_D : STATE_A;

// State flip-flops
always @(posedge clk) begin
    if (~resetn) state <= STATE_A;
    else state <= next_state;
end

// Output assignments
assign g[0] = (state == STATE_B);
assign g[1] = (state == STATE_C);
assign g[2] = (state == STATE_D);

endmodule