module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

// Define states
parameter OFF = 1'b0;
parameter ON = 1'b1;

reg current_state, next_state;

// Moore output logic
always @(*)
begin
    case(current_state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// Next state logic
always @(*)
begin
    case(current_state)
        OFF: 
            if (j == 1'b1) next_state = ON;
            else next_state = OFF;
        ON: 
            if (k == 1'b1) next_state = OFF;
            else next_state = ON;
        default: next_state = OFF;
    endcase
end

// State register
always @(posedge clk or posedge areset)
begin
    if (areset) current_state <= OFF;
    else current_state <= next_state;
end

endmodule