// Define the mux2X1 submodule
module mux2X1(
    input [7:0] a,  // First input
    input [7:0] b,  // Second input
    input sel,      // Select signal
    output [7:0] out  // Output
);
    assign out = (sel) ? b : a;
endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;

    // Stage for shifting by 4 positions
    mux2X1 stage1_mux(
        .a(in),
        .b({in[3:0], 4'b0000}),  // Shift in by 4 positions
        .sel(ctrl[2]),
        .out(stage1_out)
    );

    // Stage for shifting by 2 positions
    mux2X1 stage2_mux(
        .a(stage1_out),
        .b({stage1_out[5:0], 2'b00}),  // Shift in by 2 positions
        .sel(ctrl[1]),
        .out(stage2_out)
    );

    // Stage for shifting by 1 position
    mux2X1 stage3_mux(
        .a(stage2_out),
        .b({stage2_out[6:0], stage2_out[7]}),  // Shift in by 1 position
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
        ctrl = 3'b100;  // Test shift by 4
        #10;
        $display("Output (shift by 4): %b", out);

        in = 8'b11010011;
        ctrl = 3'b011;  // Test shift by 1 and 2
        #10;
        $display("Output (shift by 1 and 2): %b", out);

        in = 8'b11010011;
        ctrl = 3'b101;  // Test shift by 1 and 4
        #10;
        $display("Output (shift by 1 and 4): %b", out);

        in = 8'b11010011;
        ctrl = 3'b110;  // Test shift by 2 and 4
        #10;
        $display("Output (shift by 2 and 4): %b", out);

        in = 8'b11010011;
        ctrl = 3'b111;  // Test shift by 1, 2, and 4
        #10;
        $display("Output (shift by 1, 2, and 4): %b", out);
    end
endmodule