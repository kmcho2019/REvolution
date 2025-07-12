module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        case (state)
            A: begin
                if (!in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            B: begin
                if (!in) begin
                    state <= C;
                end else begin
                    state <= B;
                end
            end
            C: begin
                if (!in) begin
                    state <= A;
                end else begin
                    state <= D;
                end
            end
            D: begin
                if (!in) begin
                    state <= C;
                end else begin
                    state <= B;
                end
            end
        endcase
    end
end

always @(state) begin
    case (state)
        A, B, C: out <= 1'b0;
        D: out <= 1'b1;
    endcase
end

endmodule