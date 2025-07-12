`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states using explicit binary encoding
reg [1:0] state, next_state;
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

// Initialize the state to A
initial state = A;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Next state and output logic combined
always @(*) begin
    case (state)
        A: begin
            next_state = in ? B : A;
            out = 1'b0;
        end
        B: begin
            next_state = in ? B : C;
            out = 1'b0;
        end
        C: begin
            next_state = in ? D : A;
            out = 1'b0;
        end
        D: begin
            next_state = in ? B : C;
            out = 1'b1;
        end
        default: begin
            next_state = A;
            out = 1'b0;
        end
    endcase
end

endmodule