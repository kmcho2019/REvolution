module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// Define states
enum {OFF, ON} state, next_state;

// Assign output based on current state
always_comb begin
    case (state)
        OFF: out = 0;
        ON: out = 1;
        default: out = 0;
    endcase
end

// State transition logic
always_comb begin
    case (state)
        OFF: next_state = (j) ? ON : OFF;
        ON: next_state = (k) ? OFF : ON;
        default: next_state = OFF;
    endcase
end

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

endmodule