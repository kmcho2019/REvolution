`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
reg [1:0] state;

// ROM table for next state and output
reg [1:0] next_state;
reg output;

always @(*) begin
    case (state)
        A: begin
            next_state = in? B : A;
            output = 0;
        end
        B: begin
            next_state = in? B : C;
            output = 0;
        end
        C: begin
            next_state = in? D : A;
            output = 0;
        end
        D: begin
            next_state = in? B : C;
            output = 1;
        end
        default: begin
            next_state = A;
            output = 0;
        end
    endcase
end

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A;
        out <= 0;
    end else begin
        state <= next_state;
        out <= output;
    end
end

endmodule