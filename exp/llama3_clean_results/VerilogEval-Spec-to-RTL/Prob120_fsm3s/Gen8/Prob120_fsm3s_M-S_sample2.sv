`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states
enum logic [1:0] {A, B, C, D} state;

// Initialize the state to A
initial state = A;

// Update the state and output on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A;
        out <= 0;
    end else begin
        case (state)
            A: begin
                if (in) begin
                    state <= B;
                end else begin
                    state <= A;
                end
                out <= 0;
            end
            B: begin
                if (in) begin
                    state <= B;
                end else begin
                    state <= C;
                end
                out <= 0;
            end
            C: begin
                if (in) begin
                    state <= D;
                end else begin
                    state <= A;
                end
                out <= 0;
            end
            D: begin
                if (in) begin
                    state <= B;
                end else begin
                    state <= C;
                end
                out <= 1;
            end
            default: begin
                state <= A;
                out <= 0;
            end
        endcase
    end
end

endmodule