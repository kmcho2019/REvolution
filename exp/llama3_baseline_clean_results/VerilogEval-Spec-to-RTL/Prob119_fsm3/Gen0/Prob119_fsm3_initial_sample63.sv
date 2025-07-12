`timescale 1ns / 1ps

module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define states
enum {A, B, C, D} current_state, next_state;

always @(*) begin
    case (current_state)
        A: begin
            if (!in)
                next_state = A;
            else
                next_state = B;
            out = 0;
        end
        B: begin
            if (!in)
                next_state = C;
            else
                next_state = B;
            out = 0;
        end
        C: begin
            if (!in)
                next_state = A;
            else
                next_state = D;
            out = 0;
        end
        D: begin
            if (!in)
                next_state = C;
            else
                next_state = B;
            out = 1;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state = A;
    end else begin
        current_state = next_state;
    end
end

endmodule