module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

typedef enum logic [0:0] {
    A,
    B
} state_type;

state_type state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        A: begin
            if (~in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        default: next_state = B;
    endcase
    case (state)
        A: out = 0;
        B: out = 1;
        default: out = 1;
    endcase
end

endmodule