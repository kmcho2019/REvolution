module TopModule(
    input  logic clk,
    input  logic areset,
    input  logic in,
    output logic out
);

enum logic [0:0] {A, B} state, next_state;

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
            if (!in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        default: next_state = B;
    endcase
end

always_comb begin
    case (state)
        A: out = 0;
        B: out = 1;
        default: out = 1;
    endcase
end

endmodule