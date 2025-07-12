module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define the states
localparam OFF = 1'b0;
localparam ON  = 1'b1;

// Declare the current and next state variables
reg current_state;
reg next_state;

// Moore state machine: output is a function of the current state
always @(*)
begin
    case (current_state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'bx; // Handle undefined states
    endcase
end

// State transition logic
always @(*)
begin
    case (current_state)
        OFF:
            if (j)
                next_state = ON;
            else
                next_state = OFF;
        ON:
            if (k)
                next_state = OFF;
            else
                next_state = ON;
        default: next_state = 1'bx; // Handle undefined states
    endcase
end

// Sequential logic: update current state on clock edge
always @(posedge clk)
begin
    if (reset)
        current_state <= OFF; // Synchronous reset
    else
        current_state <= next_state;
end

endmodule