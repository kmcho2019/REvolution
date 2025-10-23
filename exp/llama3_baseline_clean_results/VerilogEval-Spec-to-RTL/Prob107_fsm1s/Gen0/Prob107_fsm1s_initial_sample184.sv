module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

typedef enum logic [1:0] {B, A} state_t;

state_t current_state, next_state;

always_comb begin
    case (current_state)
        B: begin
            if (~in) next_state = A;
            else next_state = B;
        end
        A: begin
            if (~in) next_state = B;
            else next_state = A;
        end
        default: next_state = B;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) current_state <= B;
    else current_state <= next_state;
end

always_comb begin
    case (current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0;
    endcase
end

endmodule