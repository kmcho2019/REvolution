`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define the states as an enumeration
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_type;

// Define the lookup table for next state and output
reg [1:0] state;
reg [1:0] next_state;
reg out_reg;

// Initialize the state to A
initial state = A;

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A; // Reset to state A
        out_reg <= 0; // Reset output to 0
    end else begin
        state <= next_state;
        out_reg <= out;
    end
end

// Determine the next state and output using the lookup table
always @(*) begin
    case (state)
        A: begin
            next_state = in ? B : A;
            out = 0;
        end
        B: begin
            next_state = in ? B : C;
            out = 0;
        end
        C: begin
            next_state = in ? D : A;
            out = 0;
        end
        D: begin
            next_state = in ? B : C;
            out = 1;
        end
        default: begin
            next_state = A;
            out = 0;
        end
    endcase
end

// Assign the output
assign out = out_reg;

endmodule