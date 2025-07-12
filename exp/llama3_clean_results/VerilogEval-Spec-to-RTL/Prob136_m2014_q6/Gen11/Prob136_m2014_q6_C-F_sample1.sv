`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters using a compact encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define the state register using the compact encoding
reg [2:0] currentState;

// Output z logic
assign z = (currentState >= E);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) currentState <= A;
    else begin
        case (currentState)
            A: currentState <= w ? A : B;
            B: currentState <= w ? D : C;
            C: currentState <= w ? D : E;
            D: currentState <= w ? A : F;
            E: currentState <= w ? D : E;
            F: currentState <= w ? D : C;
            default: currentState <= A;
        endcase
    end
end

endmodule