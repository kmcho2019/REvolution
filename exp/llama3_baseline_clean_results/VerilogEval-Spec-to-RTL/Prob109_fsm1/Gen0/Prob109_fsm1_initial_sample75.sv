module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

enum {A, B} state, next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B;
    end else begin
        case (state)
            A: begin
                if (~in) begin
                    next_state <= B;
                end else begin
                    next_state <= A;
                end
            end
            B: begin
                if (~in) begin
                    next_state <= A;
                end else begin
                    next_state <= B;
                end
            end
        endcase
        state <= next_state;
    end
end

always @(state) begin
    case (state)
        A: out <= 0;
        B: out <= 1;
    endcase
end

endmodule