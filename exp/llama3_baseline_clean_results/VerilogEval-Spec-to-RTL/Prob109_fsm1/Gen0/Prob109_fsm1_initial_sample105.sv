module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
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
            if (in) begin
                next_state = A;
            end else begin
                next_state = B;
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
end

assign out = state;

endmodule