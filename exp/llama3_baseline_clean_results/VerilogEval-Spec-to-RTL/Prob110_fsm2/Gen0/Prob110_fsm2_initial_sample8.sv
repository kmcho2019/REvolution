module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define states as an enum
enum logic [0:0] {OFF, ON} state, next_state;

// Output logic
always_comb begin
    case(state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
    endcase
end

// State logic
always @(*) begin
    case(state)
        OFF: begin
            if (j == 1'b1) next_state = ON;
            else next_state = OFF;
        end
        ON: begin
            if (k == 1'b1) next_state = OFF;
            else next_state = ON;
        end
    endcase
end

// D Flip-flop with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) state <= OFF;
    else state <= next_state;
end

endmodule