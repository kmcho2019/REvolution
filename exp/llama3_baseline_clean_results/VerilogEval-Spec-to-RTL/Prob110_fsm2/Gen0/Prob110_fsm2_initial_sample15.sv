module TopModule (
    input         clk,
    input         areset,
    input         j,
    input         k,
    output        out
);

// Define the states
enum logic [0:0] {OFF, ON} state, next_state;

// Next state logic
always_comb begin
    case(state)
        OFF: begin
            if (j == 1'b1)
                next_state = ON;
            else
                next_state = OFF;
        end
        ON: begin
            if (k == 1'b1)
                next_state = OFF;
            else
                next_state = ON;
        end
        default: next_state = OFF;
    endcase
end

// Output logic
always_comb begin
    case(state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'bx;
    endcase
end

// State register with asynchronous reset
always_ff @(posedge clk or posedge areset) begin
    if (areset)
        state <= OFF;
    else
        state <= next_state;
end

endmodule