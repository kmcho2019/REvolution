module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

typedef enum logic[0:0] {
    B,
    A
} state_t;

state_t state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        B: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        A: begin
            if (!in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        default: begin
            next_state = B; // Default to state B
        end
    endcase
end

always @(*) begin
    case(state)
        B: out = 1;
        A: out = 0;
        default: out = 1; // Default output when in an unknown state
    endcase
end

endmodule