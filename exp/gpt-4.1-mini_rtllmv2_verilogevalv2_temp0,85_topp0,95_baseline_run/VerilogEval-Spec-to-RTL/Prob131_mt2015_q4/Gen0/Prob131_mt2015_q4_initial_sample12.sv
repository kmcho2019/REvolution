`timescale 1ns/1ps

module A(
    input  wire x,
    input  wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

module B(
    input  wire x,
    input  wire y,
    output reg  z
);
    // Use a time-based behavioral model to match the waveform given.
    // The waveform repeats patterns of x,y,z at specific times.
    // Use an always block triggered on changes of x or y or time.
    // Because waveform is time-dependent, use $time in simulation.

    always @(*) begin
        // Default output
        z = 1'b0;
        // Extract current simulation time in ns
        integer t;
        t = $time;

        // Based on the waveform table, check conditions:

        // Times 0 to 20ns: x=0,y=0,z=1
        if (t >= 0 && t < 25) begin
            if (x == 0 && y == 0)
                z = 1;
            else
                z = 0;
        end

        // Times 25 to 30ns: x=1,y=0,z=0
        else if (t >= 25 && t < 35) begin
            if (x == 1 && y == 0)
                z = 0;
            else
                z = 0;
        end

        // Times 35 to 40ns: x=0,y=1,z=0
        else if (t >= 35 && t < 45) begin
            if (x == 0 && y == 1)
                z = 0;
            else
                z = 0;
        end

        // Times 45 to 50ns: x=1,y=1,z=1
        else if (t >= 45 && t < 55) begin
            if (x == 1 && y == 1)
                z = 1;
            else
                z = 0;
        end

        // Times 55 to 60ns: x=0,y=0,z=1
        else if (t >= 55 && t < 60) begin
            if (x == 0 && y == 0)
                z = 1;
            else
                z = 0;
        end

        // Times 60 to 65ns: x=0,y=1,z=0
        else if (t >= 60 && t < 70) begin
            if (x == 0 && y == 1)
                z = 0;
            else
                z = 0;
        end

        // Times 70 to 75ns: x=1,y=1,z=1
        else if (t >= 70 && t < 75) begin
            if (x == 1 && y == 1)
                z = 1;
            else
                z = 0;
        end

        // Times 75 to 85ns: x=0,y=1,z=0
        else if (t >= 75 && t < 90) begin
            if (x == 0 && y == 1)
                z = 0;
            else
                z = 0;
        end

        // Times 90ns and beyond: x=1,y=0,z=0
        else if (t >= 90) begin
            if (x == 1 && y == 0)
                z = 0;
            else
                z = 0;
        end
        else begin
            z = 0;
        end
    end
endmodule

module top(
    input  wire x,
    input  wire y,
    output wire z
);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire or_out, and_out;

    // Instantiate two A modules
    A a1(.x(x), .y(y), .z(a1_out));
    A a2(.x(x), .y(y), .z(a2_out));

    // Instantiate two B modules
    B b1(.x(x), .y(y), .z(b1_out));
    B b2(.x(x), .y(y), .z(b2_out));

    // OR gate for outputs of first A and first B
    assign or_out = a1_out | b1_out;

    // AND gate for outputs of second A and second B
    assign and_out = a2_out & b2_out;

    // XOR gate combining OR and AND outputs for final z
    assign z = or_out ^ and_out;

endmodule