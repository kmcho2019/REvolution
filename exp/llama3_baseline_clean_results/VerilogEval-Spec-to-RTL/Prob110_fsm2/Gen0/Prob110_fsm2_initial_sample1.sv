module TopModule(
    input         clk,
    input         areset,
    input         j,
    input         k,
    output        out
);

// Define states
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// State register
reg current_state;
reg next_state;

// Output logic
assign out = current_state;

// Next state logic
always @(*)
begin
    case(current_state)
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
        default:
            next_state = OFF;
    endcase
end

// State transition
always @(posedge clk or posedge areset)
begin
    if (areset == 1'b1)
        current_state <= OFF;
    else
        current_state <= next_state;
end

endmodule