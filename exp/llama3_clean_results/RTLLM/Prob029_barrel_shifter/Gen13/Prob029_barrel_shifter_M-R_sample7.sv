module mux2X1(
    input [7:0] in0,  // First input
    input [7:0] in1,  // Second input
    input sel,        // Select signal
    output [7:0] out  // Output
);

    // Use a simple conditional statement to select the output
    assign out = sel ? in1 : in0;

endmodule

module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Intermediate wires for the outputs of each stage
    wire [7:0] shift_by_1;
    wire [7:0] shift_by_2;
    wire [7:0] shift_by_4;

    // Stage 1: Shift by 1 position if ctrl[0] is high
    mux2X1 stage1_shift_by_1(
        .in0(in),          // Original input
        .in1({in[6:0], 1'b0}),  // Input shifted by 1 position
        .sel(ctrl[0]),
        .out(shift_by_1)
    );

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage2_shift_by_2(
        .in0(shift_by_1),  // Output from previous stage
        .in1({shift_by_1[5:0], 2'b00}),  // Shifted by 2 positions
        .sel(ctrl[1]),
        .out(shift_by_2)
    );

    // Stage 3: Shift by 4 positions if ctrl[2] is high
    mux2X1 stage3_shift_by_4(
        .in0(shift_by_2),  // Output from previous stage
        .in1({shift_by_2[3:0], 4'b0000}),  // Shifted by 4 positions
        .sel(ctrl[2]),
        .out(shift_by_4)
    );

    // Final output is the result after all stages
    assign out = shift_by_4;

endmodule

// Testbench for the barrel shifter
module barrel_shifter_testbench;
    reg [7:0] in;
    reg [2:0] ctrl;
    wire [7:0] out;

    barrel_shifter uut (
       .in(in),
       .ctrl(ctrl),
       .out(out)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        in = 8'b11010011;
        ctrl = 3'b000;  // Test no shift
        #10;
        $display("Output (no shift): %b", out);

        in = 8'b11010011;
        ctrl = 3'b001;  // Test shift by 1
        #10;
        $display("Output (shift by 1): %b", out);

        in = 8'b11010011;
        ctrl = 3'b010;  // Test shift by 2
        #10;
        $display("Output (shift by 2): %b", out);

        in = 8'b11010011;
        ctrl = 3'b100;  // Test shift by 4
        #10;
        $display("Output (shift by 4): %b", out);

        in = 8'b11010011;
        ctrl = 3'b011;  // Test shift by 3 (1+2)
        #10;
        $display("Output (shift by 3): %b", out);

        in = 8'b11010011;
        ctrl = 3'b101;  // Test shift by 5 (1+4)
        #10;
        $display("Output (shift by 5): %b", out);

        in = 8'b11010011;
        ctrl = 3'b110;  // Test shift by 6 (2+4)
        #10;
        $display("Output (shift by 6): %b", out);

        in = 8'b11010011;
        ctrl = 3'b111;  // Test shift by 7 (1+2+4)
        #10;
        $display("Output (shift by 7): %b", out);

        #10;
        $finish;
    end
endmodule