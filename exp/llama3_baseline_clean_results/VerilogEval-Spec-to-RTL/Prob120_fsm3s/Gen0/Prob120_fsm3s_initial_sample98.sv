`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

// Declare the current state register
reg [1:0] current_state;

// Initialize the state to A
initial current_state = A;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: current_state <= in ? B : A;
            B: current_state <= in ? B : C;
            C: current_state <= in ? D : A;
            D: current_state <= in ? B : C;
            default: current_state <= A;
        endcase
    end
end

// Output logic
always @(current_state) begin
    case (current_state)
        A, B, C: out <= 0;
        D: out <= 1;
    endcase
end

endmodule