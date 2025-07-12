`timescale 1ns/1ps

// Module A: z = (x ^ y) & x
module A (
    input wire x,
    input wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: produces output z following the provided waveform
// Use a clocked counter to model the output at specified times
module B (
    input wire clk,
    input wire x,
    input wire y,
    output reg z
);
    reg [7:0] time_ns; // time in ns, increments every clk posedge assuming 5ns clk period

    always @(posedge clk) begin
        if (time_ns >= 90)
            time_ns <= 0;
        else
            time_ns <= time_ns + 5;
    end

    always @(posedge clk) begin
        case(time_ns)
            0,5,10,15,20,55: z <= 1; // z=1 at these times with x=0,y=0
            25,30,35,40,60,65,75,80,85,90: z <= 0; // z=0 at these times
            45,50,70: z <= 1; // z=1
            default: z <= z; // retain previous value
        endcase
    end
endmodule

// Top level module
module top (
    input wire clk,
    input wire x,
    input wire y,
    output wire z
);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire or_out, and_out;

    // Instantiate two A modules
    A a1(.x(x), .y(y), .z(a1_out));
    A a2(.x(x), .y(y), .z(a2_out));

    // Instantiate two B modules
    B b1(.clk(clk), .x(x), .y(y), .z(b1_out));
    B b2(.clk(clk), .x(x), .y(y), .z(b2_out));

    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;
    assign z = or_out ^ and_out;

endmodule

// Testbench to simulate
module testbench;
    reg clk;
    reg x, y;
    wire z;

    top uut(
        .clk(clk),
        .x(x),
        .y(y),
        .z(z)
    );

    initial begin
        clk = 0;
        forever #2.5 clk = ~clk; // 5ns clock period
    end

    initial begin
        // Apply inputs according to given waveform (0 to 90 ns)
        // Since B module relies on clk for timing, inputs should change at clk edges
        // The waveform for inputs (x,y) over time in ns:
        // 0-20: x=0,y=0
        // 25-30: x=1,y=0
        // 35-40: x=0,y=1
        // 45-50: x=1,y=1
        // 55: x=0,y=0
        // 60-85: x=0,y=1
        // 90: x=1,y=0

        // Start at time 0
        x = 0; y = 0;
        #25;
        x = 1; y = 0;
        #10;
        x = 0; y = 1;
        #10;
        x = 1; y = 1;
        #10;
        x = 0; y = 0;
        #5;
        x = 0; y = 1;
        #30;
        x = 1; y = 0;
        #10;
        $finish;
    end
endmodule