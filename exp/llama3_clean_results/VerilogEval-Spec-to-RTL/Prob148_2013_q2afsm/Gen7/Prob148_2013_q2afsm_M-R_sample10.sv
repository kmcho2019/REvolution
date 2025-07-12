module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define state codes
parameter STATE_A = 2'b00;
parameter STATE_B = 2'b01;
parameter STATE_C = 2'b10;
parameter STATE_D = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

// Next state logic using conditional statements
assign next_state = (state == STATE_A && r[0])? STATE_B :
                    (state == STATE_A &&!r[0] && r[1])? STATE_C :
                    (state == STATE_A &&!r[0] &&!r[1] && r[2])? STATE_D :
                    (state == STATE_B &&!r[0])? STATE_A :
                    (state == STATE_C &&!r[1])? STATE_A :
                    (state == STATE_D &&!r[2])? STATE_A :
                    state;

// State flip-flops update
always @(posedge clk) begin
    if (~resetn) state <= STATE_A;
    else state <= next_state;
end

// Output logic
assign g[0] = (state == STATE_B);
assign g[1] = (state == STATE_C);
assign g[2] = (state == STATE_D);

endmodule