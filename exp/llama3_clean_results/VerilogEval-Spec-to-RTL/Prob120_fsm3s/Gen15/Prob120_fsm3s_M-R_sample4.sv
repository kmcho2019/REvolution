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
        out <= 0;
    end else begin
        case (state)
            A: if (in) state <= B; else state <= A;
            B: if (in) state <= B; else state <= C;
            C: if (in) state <= D; else state <= A;
            D: if (in) state <= B; else state <= C;
        endcase
        // Assign output based on current state
        out <= (state == D) ? 1 : 0;
    end
end

endmodule