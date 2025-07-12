module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

typedef enum logic [2:0] {
    A = 3'd0,
    B = 3'd1,
    C = 3'd2,
    D = 3'd3,
    E = 3'd4,
    F = 3'd5
} state_t;

state_t state, next_state;

always @(posedge clk) begin
    if (reset)
        state <= A;
    else
        state <= next_state;
end

always @(*) begin
    case(state)
        A: begin
            z = 1'b0;
            next_state = w ? B : A;
        end
        B: begin
            z = 1'b0;
            next_state = w ? C : D;
        end
        C: begin
            z = 1'b0;
            next_state = w ? E : D;
        end
        D: begin
            z = 1'b0;
            next_state = w ? F : A;
        end
        E: begin
            z = 1'b1;
            next_state = w ? E : D;
        end
        F: begin
            z = 1'b1;
            next_state = w ? C : D;
        end
        default: begin
            z = 1'b0;
            next_state = A;
        end
    endcase
end

endmodule