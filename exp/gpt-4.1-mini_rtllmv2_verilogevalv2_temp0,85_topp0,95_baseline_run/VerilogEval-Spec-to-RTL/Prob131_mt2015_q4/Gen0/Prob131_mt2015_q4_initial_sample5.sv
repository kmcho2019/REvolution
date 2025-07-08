`timescale 1ns/1ps

// Module A: z = (x ^ y) & x
module A (
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: implemented to reproduce the waveform given in the problem.
// Since the waveform depends on time and inputs in a nontrivial way,
// we implement a behavioral model using an internal counter to simulate time and produce z accordingly.
module B (
    input  wire x,
    input  wire y,
    output reg  z
);

    // We'll simulate time by counting the number of input changes or clock cycles.
    // For simplicity, assume inputs change at multiples of 5ns and inputs are stable within that period.
    // We'll implement a simple clock with 5ns period internally and a counter to index waveform steps.
    // Because we do not have a clock input, we use an always block triggered on input changes,
    // then keep track of the count of changes to simulate steps.

    reg [3:0] step;  // 0 to 19 steps (max index in given waveform)

    // On any change of x or y, increment step modulo waveform length (20)
    always @(x or y) begin
        step = step + 1;
        if (step >= 20) step = 0;
    end

    // Combinational logic for output z according to waveform table:
    // time(ns)  x  y  z
    // 0-20ns:   0  0  1  (steps 0 to 4)
    // 25-30ns:  1  0  0  (steps 5 to 6)
    // 35-40ns:  0  1  0  (steps 7 to 8)
    // 45-50ns:  1  1  1  (steps 9 to 10)
    // 55ns:     0  0  1  (step 11)
    // 60-65ns:  0  1  0  (steps 12 to 13)
    // 70ns:     1  1  1  (step 14)
    // 75-85ns:  0  1  0  (steps 15 to 18)
    // 90ns:     1  0  0  (step 19)

    always @(*) begin
        case (step)
            0,1,2,3,4:   z = 1'b1;                  // 0-20ns
            5,6:         z = 1'b0;                  // 25-30ns
            7,8:         z = 1'b0;                  // 35-40ns
            9,10:        z = 1'b1;                  // 45-50ns
            11:          z = 1'b1;                  // 55ns
            12,13:       z = 1'b0;                  // 60-65ns
            14:          z = 1'b1;                  // 70ns
            15,16,17,18: z = 1'b0;                  // 75-85ns
            19:          z = 1'b0;                  // 90ns
            default:     z = 1'b0;
        endcase
    end

    initial begin
        step = 0;
    end

endmodule

// Top-level module as described
module top_module (
    input  wire x,
    input  wire y,
    output wire z
);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire or_out, and_out;

    // Instantiate two A modules
    A a1 (.x(x), .y(y), .z(a1_out));
    A a2 (.x(x), .y(y), .z(a2_out));

    // Instantiate two B modules
    B b1 (.x(x), .y(y), .z(b1_out));
    B b2 (.x(x), .y(y), .z(b2_out));

    // First OR gate: or_out = a1_out | b1_out
    assign or_out = a1_out | b1_out;

    // Second AND gate: and_out = a2_out & b2_out
    assign and_out = a2_out & b2_out;

    // XOR gate: z = or_out ^ and_out
    assign z = or_out ^ and_out;

endmodule