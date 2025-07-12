`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states with explicit binary encoding
reg [1:0] state, next_state;
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Determine the next state and output
always @(*) begin
    case (state)
        A: begin
            if (in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
            out = 0;
        end
        B: begin
            if (in) begin
                next_state = B;
            end else begin
                next_state = C;
            end
            out = 0;
        end
        C: begin
            if (in) begin
                next_state = D;
            end else begin
                next_state = A;
            end
            out = 0;
        end
        D: begin
            if (in) begin
                next_state = B;
            end else begin
                next_state = C;
            end
            out = 1;
        end
        default: begin
            next_state = A;
            out = 0;
        end
    endcase
end

endmodule