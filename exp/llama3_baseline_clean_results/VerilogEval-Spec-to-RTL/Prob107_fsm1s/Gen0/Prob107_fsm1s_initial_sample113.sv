module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
parameter STATE_B = 1'b0, STATE_A = 1'b1;

// Declare the state register
reg current_state;
reg next_state;

// Output logic
always @(current_state)
begin
    case(current_state)
        STATE_B: out = 1'b1;
        STATE_A: out = 1'b0;
        default: out = 1'b0; // default case, in case of unknown state
    endcase
end

// Next state logic
always @(*)
begin
    case(current_state)
        STATE_B:
            if(in == 1'b0)
                next_state = STATE_A;
            else
                next_state = STATE_B;
        STATE_A:
            if(in == 1'b0)
                next_state = STATE_B;
            else
                next_state = STATE_A;
        default:
            next_state = STATE_B; // default to reset state for unknown current state
    endcase
end

// Update state on clock edge
always @(posedge clk)
begin
    if(reset) // synchronous active-high reset
        current_state <= STATE_B;
    else
        current_state <= next_state;
end

endmodule