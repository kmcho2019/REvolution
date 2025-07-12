module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State codes
parameter STATE_A = 2'b00;
parameter STATE_B = 2'b01;
parameter STATE_C = 2'b10;
parameter STATE_D = 2'b11;

// Current state and next state
reg [1:0] currentState, nextState;

// Output g
assign g[0] = (currentState == STATE_B);
assign g[1] = (currentState == STATE_C);
assign g[2] = (currentState == STATE_D);

// Next state logic
always @(*)
begin
    case (currentState)
        STATE_A:
            if (r[0] == 1'b1)
                nextState = STATE_B;
            else if (r[1] == 1'b1)
                nextState = STATE_C;
            else if (r[2] == 1'b1)
                nextState = STATE_D;
            else
                nextState = STATE_A;
        STATE_B:
            if (r[0] == 1'b1)
                nextState = STATE_B;
            else
                nextState = STATE_A;
        STATE_C:
            if (r[1] == 1'b1)
                nextState = STATE_C;
            else
                nextState = STATE_A;
        STATE_D:
            if (r[2] == 1'b1)
                nextState = STATE_D;
            else
                nextState = STATE_A;
        default:
            nextState = STATE_A;
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if (!resetn)
        currentState <= STATE_A;
    else
        currentState <= nextState;
end

endmodule