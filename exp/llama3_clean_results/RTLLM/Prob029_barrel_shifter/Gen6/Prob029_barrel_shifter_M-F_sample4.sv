// Define the mux2X1 module
module mux2X1(
    input [7:0] in0,  // First input
    input [7:0] in1,  // Second input
    input sel,        // Select signal
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
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;
    wire [7:0] stage3_out;

    // Stage 1: Shift by 1 position if ctrl[0] is high
    mux2X1 stage1(
        .in0(in),
        .in1({in[6:0], in[7]}),
        .sel(ctrl[0]),
        .out(stage1_out)
    );

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage2(
        .in0(stage1_out),
        .in1({stage1_out[5:0], stage1_out[7:6]}),
        .sel(ctrl[1]),
        .out(stage2_out)
    );

    // Stage 3: Shift by 4 positions if ctrl[2] is high
    mux2X1 stage3(
        .in0(stage2_out),
        .in1({stage2_out[3:0], stage2_out[7:4]}),
        .sel(ctrl[2]),
        .out(stage3_out)
    );

    assign out = stage3_out;
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