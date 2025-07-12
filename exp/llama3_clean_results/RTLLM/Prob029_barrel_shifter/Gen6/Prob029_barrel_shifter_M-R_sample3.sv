// Define the mux2X1 submodule
module mux2X1(
    input [7:0] in0,  // First input
    input [7:0] in1,  // Second input
    input sel,  // Select signal
    output [7:0] out  // Output
);
    assign out = sel ? in1 : in0;
endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);
    wire [7:0] shift4, shift2, shift1;

    // Shift by 4 positions
    mux2X1 mux4(
        .in0(in),
        .in1({in[3:0], in[7:4]}),
        .sel(ctrl[2]),
        .out(shift4)
    );

    // Shift by 2 positions
    mux2X1 mux2(
        .in0(shift4),
        .in1({shift4[5:0], shift4[7:6]}),
        .sel(ctrl[1]),
        .out(shift2)
    );

    // Shift by 1 position
    mux2X1 mux1(
        .in0(shift2),
        .in1({shift2[6:0], shift2[7]}),
        .sel(ctrl[0]),
        .out(out)
    );
endmodule

// Testbench for the barrel_shifter module
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
        ctrl = 3'b011;  // Test shift by 3
        #10;
        $display("Output (shift by 3): %b", out);

        in = 8'b11010011;
        ctrl = 3'b100;  // Test shift by 4
        #10;
        $display("Output (shift by 4): %b", out);

        in = 8'b11010011;
        ctrl = 3'b101;  // Test shift by 5
        #10;
        $display("Output (shift by 5): %b", out);

        in = 8'b11010011;
        ctrl = 3'b110;  // Test shift by 6
        #10;
        $display("Output (shift by 6): %b", out);

        in = 8'b11010011;
        ctrl = 3'b111;  // Test shift by 7
        #10;
        $display("Output (shift by 7): %b", out);
    end
endmodule