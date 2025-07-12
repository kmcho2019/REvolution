module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define states
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// Declare current and next state
reg current_state;
reg next_state;

// Output is determined by the current state
assign out = current_state;

// Combinational logic to determine next state
always @(*)
begin
    case(current_state)
        OFF:
        begin
            if (j == 1'b1)
                next_state = ON;
            else
                next_state = OFF;
        end
        ON:
        begin
            if (k == 1'b1)
                next_state = OFF;
            else
                next_state = ON;
        end
        default: next_state = OFF;
    endcase
end

// Sequential logic to update current state
always @(posedge clk)
begin
    if (reset == 1'b1)
        current_state <= OFF;
    else
        current_state <= next_state;
end

endmodule