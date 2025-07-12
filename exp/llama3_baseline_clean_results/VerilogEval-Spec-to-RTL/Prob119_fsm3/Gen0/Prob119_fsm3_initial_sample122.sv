module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

// Define states as enumerations
enum {A, B, C, D} state, next_state;

always @(*) begin
    case (state)
        A: begin
            if (!in) next_state = A;
            else next_state = B;
            out = 0;
        end
        B: begin
            if (!in) next_state = C;
            else next_state = B;
            out = 0;
        end
        C: begin
            if (!in) next_state = A;
            else next_state = D;
            out = 0;
        end
        D: begin
            if (!in) next_state = C;
            else next_state = B;
            out = 1;
        end
        default: begin
            next_state = A;
            out = 0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule