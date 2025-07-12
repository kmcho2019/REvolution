module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define state codes as parameters
parameter STATE_A = 2'b00,
          STATE_B = 2'b01,
          STATE_C = 2'b10;

// Declare the current state and next state
reg [1:0] current_state, next_state;

// Continuous assignment for outputs g[i]
assign g[0] = (current_state == STATE_B);
assign g[1] = (current_state == STATE_C);
assign g[2] = 1'b0; // Since there's no direct connection for g[2] in the state machine

// Always block for next state logic
always @(*)
begin
    case(current_state)
        STATE_A:
            if (r[0] == 1'b1)
                next_state = STATE_B;
            else if (r[1] == 1'b1)
                next_state = STATE_C;
            else
                next_state = STATE_A;
        STATE_B:
            if (r[0] == 1'b1)
                next_state = STATE_B;
            else
                next_state = STATE_A;
        STATE_C:
            if (r[1] == 1'b1)
                next_state = STATE_C;
            else
                next_state = STATE_A;
        default:
            next_state = STATE_A;
    endcase
end

// Always block for state flip-flops
always @(posedge clk)
begin
    if (~resetn)
        current_state <= STATE_A;
    else
        current_state <= next_state;
end

endmodule