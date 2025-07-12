module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg [0:0] current_state; // current state (0 - OFF, 1 - ON)
reg [0:0] next_state;   // next state

// State encoding
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// Combinational logic for the next state
always @(*)
begin
    case (current_state)
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

// Sequential logic for the current state
always @(posedge clk or posedge areset)
begin
    if (areset)
        current_state <= OFF; // asynchronous reset to OFF state
    else
        current_state <= next_state;
end

// Combinational logic for the output
always @(*)
begin
    case (current_state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule