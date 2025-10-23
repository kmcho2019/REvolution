module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

typedef enum logic[1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_type;

state_type state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case(state)
        A: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if (!in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
        end
        C: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = D;
            end
        end
        D: begin
            if (!in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
        end
        default: next_state = A;
    endcase
end

always_comb begin
    case(state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule