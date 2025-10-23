module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

// Define states
localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg current_state;
reg next_state;

// Combinational logic to determine next state
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
        default:
            next_state = OFF;
    endcase
end

// Sequential logic for state register and output
always @(posedge clk)
begin
    if (reset)
        current_state <= OFF;
    else
        current_state <= next_state;
end

// Output logic (Moore machine)
always @(*)
begin
    case (current_state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule