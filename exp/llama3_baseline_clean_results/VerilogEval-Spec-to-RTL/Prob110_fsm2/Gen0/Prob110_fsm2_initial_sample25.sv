module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

// Define the states
enum logic [0:0] {OFF, ON} current_state, next_state;

// Handle asynchronous reset
always @(posedge clk or posedge areset)
begin
    if(areset)
        current_state <= OFF;
    else
        current_state <= next_state;
end

// Determine next state
always @(*)
begin
    case(current_state)
        OFF: 
            if(j)
                next_state <= ON;
            else
                next_state <= OFF;
        ON: 
            if(k)
                next_state <= OFF;
            else
                next_state <= ON;
        default: next_state <= OFF;
    endcase
end

// Determine output
always @(*)
begin
    case(current_state)
        OFF: out <= 0;
        ON: out <= 1;
        default: out <= 0;
    endcase
end

endmodule