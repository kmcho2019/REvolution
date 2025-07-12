`timescale 1ns/1ps

// Module A: z = (x ^ y) & x
module A (
    input wire x,
    input wire y,
    output wire z
);
    assign z = (x ^ y) & x;
endmodule

// Module B: combinational logic with inputs x, y, and time_index (0..18)
// Produces output z based on the provided waveform timing and inputs
module B (
    input wire x,
    input wire y,
    input wire [4:0] time_index, // index corresponding to 0ns,5ns,...,90ns
    output reg z
);
    // Waveform mapping extracted from the problem's table:
    // time(ns) : x y | z
    //  0-20 (indices 0..4)    0 0 : z=1
    //  25-30 (indices 5..6)   1 0 : z=0
    //  35-40 (indices 7..8)   0 1 : z=0
    //  45-50 (indices 9..10)  1 1 : z=1
    //  55 (index 11)           0 0 : z=1
    //  60-85 (indices 12..17)  0 1 : z=0
    //  90 (index 18)           1 0 : z=0

    // We'll encode these conditions exactly as in the waveform.
    always @(*) begin
        case(time_index)
            5'd0,5'd1,5'd2,5'd3,5'd4,5'd11: begin
                // times 0,5,10,15,20,55 ns
                if (x == 1'b0 && y == 1'b0)
                    z = 1'b1;
                else
                    z = 1'b0; // if inputs not matching, default 0
            end
            5'd5,5'd6,5'd7,5'd8,5'd12,5'd13,5'd14,5'd15,5'd16,5'd17,5'd18: begin
                // times 25,30,35,40,60,65,70,75,80,85,90 ns (mostly 0)
                // The only '1' at 70 ns will be handled below
                z = 1'b0;
            end
            5'd9,5'd10: begin
                // 45,50 ns: x=1,y=1 z=1
                if (x == 1'b1 && y == 1'b1)
                    z = 1'b1;
                else
                    z = 1'b0;
            end
            5'd14: begin
                // 70 ns time: x=1,y=1 z=1 (special case)
                if (x == 1'b1 && y == 1'b1)
                    z = 1'b1;
                else
                    z = 1'b0;
            end
            default: z = 1'b0;
        endcase
    end
endmodule

// Top module: connects two A modules and two B modules
// Combines outputs as per specification:
// z = ( (a1_out | b1_out) ^ (a2_out & b2_out) )
module top (
    input wire x,
    input wire y,
    input wire [4:0] time_index,
    output wire z
);
    wire a1_out, a2_out;
    wire b1_out, b2_out;

    A a1 (.x(x), .y(y), .z(a1_out));
    A a2 (.x(x), .y(y), .z(a2_out));

    B b1 (.x(x), .y(y), .time_index(time_index), .z(b1_out));
    B b2 (.x(x), .y(y), .time_index(time_index), .z(b2_out));

    wire or_out = a1_out | b1_out;
    wire and_out = a2_out & b2_out;

    assign z = or_out ^ and_out;
endmodule

// Testbench: generates inputs x,y according to waveform and increments time_index every 5ns
module testbench;
    reg x;
    reg y;
    reg [4:0] time_index; // 0..18 corresponding to 0ns..90ns every 5ns
    wire z;

    // Instantiate top
    top uut (
        .x(x),
        .y(y),
        .time_index(time_index),
        .z(z)
    );

    initial begin
        // Initialize
        time_index = 0;
        x = 0; y = 0;
        #1; // small delay to start

        forever begin
            // Apply inputs for each time step according to the problem's waveform
            case (time_index)
                5'd0,5'd1,5'd2,5'd3,5'd4: begin // 0ns-20ns
                    x = 0; y = 0;
                end
                5'd5,5'd6: begin // 25ns-30ns
                    x = 1; y = 0;
                end
                5'd7,5'd8: begin // 35ns-40ns
                    x = 0; y = 1;
                end
                5'd9,5'd10: begin // 45ns-50ns
                    x = 1; y = 1;
                end
                5'd11: begin // 55ns
                    x = 0; y = 0;
                end
                5'd12,5'd13,5'd14,5'd15,5'd16,5'd17: begin // 60ns-85ns
                    x = 0; y = 1;
                end
                5'd18: begin // 90ns
                    x = 1; y = 0;
                end
                default: begin
                    x = 0; y = 0;
                end
            endcase

            #5; // wait 5 ns

            if (time_index == 18)
                $finish;
            else
                time_index = time_index + 1;
        end
    end

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0,testbench);
    end
endmodule