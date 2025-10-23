module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define the states
parameter OFF = 1'b0;
parameter ON = 1'b1;

// Register to store the current state
reg current_state;
reg next_state;

// Assign the output based on the current state
always @(current_state)
    case(current_state)
        OFF: out <= 1'b0;
        ON:  out <= 1'b1;
        default: out <= 1'b0;
    endcase

// Next state logic
always @(current_state, j, k)
    case(current_state)
        OFF:
            if(j == 1'b1)
                next_state = ON;
            else
                next_state = OFF;
        ON:
            if(k == 1'b1)
                next_state = OFF;
            else
                next_state = ON;
        default: next_state = OFF;
    endcase

// Update the current state on the rising edge of the clock
always @(posedge clk)
    if(reset == 1'b1)
        current_state <= OFF;
    else
        current_state <= next_state;

// Initialize the current state
initial
    current_state = OFF;

endmodule