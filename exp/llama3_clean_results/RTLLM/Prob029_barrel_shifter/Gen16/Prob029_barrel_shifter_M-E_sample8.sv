module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Internal signals for stage outputs
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;

    // Shift Amount Decoder
    wire shift1_en;
    wire shift2_en;
    wire shift4_en;

    assign shift1_en = ctrl[0];
    assign shift2_en = ctrl[1];
    assign shift4_en = ctrl[2];

    // Stage 1: 1-bit Shift Module
    mux2x1 #(.WIDTH(8)) stage1_mux(
        .in0(in),
        .in1({in[6:0], 1'b0}),  // Shift in by 1 bit
        .sel(shift1_en),
        .out(stage1_out)
    );

    // Stage 2: 2-bit Shift Module
    mux2x1 #(.WIDTH(8)) stage2_mux(
        .in0(stage1_out),
        .in1({stage1_out[5:0], 2'b00}),  // Shift in by 2 bits
        .sel(shift2_en),
        .out(stage2_out)
    );

    // Stage 3: 4-bit Shift Module
    mux2x1 #(.WIDTH(8)) stage3_mux(
        .in0(stage2_out),
        .in1({stage2_out[3:0], 4'b0000}),  // Shift in by 4 bits
        .sel(shift4_en),
        .out(out)
    );

endmodule

// 2-to-1 Multiplexer module
module mux2x1 #(
    parameter WIDTH = 8
)(
    input [WIDTH-1:0] in0,
    input [WIDTH-1:0] in1,
    input sel,
    output [WIDTH-1:0] out
);

    assign out = sel ? in1 : in0;

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