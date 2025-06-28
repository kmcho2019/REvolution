module TopModule (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);

// Define states
typedef enum { OFF, ON } state_type;
reg state, next_state;

// State machine with synchronous reset
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// State transition logic
always @* begin
    case(state)
        OFF: next_state = (j) ? ON : OFF;
        ON: next_state = (k) ? OFF : ON;
    endcase
end

// Output generation based on state
always @* begin
    case(state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
    endcase
end

endmodule