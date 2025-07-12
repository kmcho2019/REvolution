`timescale 1ns / 1ps

module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define states
enum logic [1:0] {A, B, C, D} state, next_state;

// State transition logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        case (state)
            A: begin
                if (~in) begin
                    next_state <= A;
                end else begin
                    next_state <= B;
                end
            end
            B: begin
                if (~in) begin
                    next_state <= C;
                end else begin
                    next_state <= B;
                end
            end
            C: begin
                if (~in) begin
                    next_state <= A;
                end else begin
                    next_state <= D;
                end
            end
            D: begin
                if (~in) begin
                    next_state <= C;
                end else begin
                    next_state <= B;
                end
            end
        endcase
        state <= next_state;
    end
end

// Output logic
always_comb begin
    case (state)
        A, B, C: begin
            out = 0;
        end
        D: begin
            out = 1;
        end
    endcase
end

endmodule