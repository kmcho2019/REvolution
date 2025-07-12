module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // Use a single-bit reg to store the state
reg [0:0] next_state; // Use a single-bit reg to store the next state

// Define the states
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// Output logic
assign out = state;

// Next state logic
always @(*)
begin
    case(state)
        OFF:
            if (j == 1'b1)
                next_state = ON;
            else
                next_state = OFF;
        ON:
            if (k == 1'b1)
                next_state = OFF;
            else
                next_state = ON;
        default: next_state = OFF;
    endcase
end

// State register
always @(posedge clk)
begin
    if (reset == 1'b1)
        state <= OFF;
    else
        state <= next_state;
end

endmodule