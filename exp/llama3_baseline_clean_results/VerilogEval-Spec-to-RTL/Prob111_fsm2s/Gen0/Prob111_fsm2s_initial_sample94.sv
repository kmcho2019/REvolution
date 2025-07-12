module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define states
parameter OFF = 1'b0;
parameter ON  = 1'b1;

reg current_state;
reg next_state;

// Determine output based on current state
always @(*)
begin
    case(current_state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'bx; // undefined state
    endcase
end

// Determine next state based on current state and inputs
always @(*)
begin
    case(current_state)
        OFF: 
        begin
            if (j == 1'b1) next_state = ON;
            else next_state = OFF;
        end
        ON: 
        begin
            if (k == 1'b1) next_state = OFF;
            else next_state = ON;
        end
        default: next_state = OFF; // default to OFF if in an undefined state
    endcase
end

// Synchronize state machine with clock and handle reset
always @(posedge clk or posedge reset)
begin
    if (reset)
        current_state <= OFF;
    else
        current_state <= next_state;
end

endmodule