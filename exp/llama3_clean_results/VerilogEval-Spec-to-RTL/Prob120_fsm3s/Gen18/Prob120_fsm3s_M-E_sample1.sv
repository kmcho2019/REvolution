`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states
parameter A = 0, B = 1, C = 2, D = 3;
reg [1:0] state;

// Initialize the state to A
initial state = A;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        case (state)
            A: state <= in? B : A;
            B: state <= in? B : C;
            C: state <= in? D : A;
            D: state <= in? B : C;
            default: state <= A;
        endcase
    end
end

// Output logic
always @(posedge clk) begin
    case (state)
        A: out <= 0;
        B: out <= 0;
        C: out <= 0;
        D: out <= 1;
        default: out <= 0;
    endcase
end

endmodule