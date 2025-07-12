// Define the bit_shifter submodule
module bit_shifter(
    input [7:0] in0,  // First input
    input [7:0] in1,  // Second input
    input sel,       // Select signal
    output reg [7:0] out  // Output
);
    always @(*) begin
        out = sel? in1 : in0;
    end
endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output reg [7:0] out  // Shifted output
);
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;

    // Stage 1: Shift by 1, 2, or 4 positions based on ctrl[0], ctrl[1], and ctrl[2]
    bit_shifter stage1_mux(
      .in0(in),
      .in1({in[6:0], in[7]}),  // Shift by 1
      .sel(ctrl[0]),
      .out(stage1_out)
    );

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    bit_shifter stage2_mux(
      .in0(stage1_out),
      .in1({stage1_out[5:0], stage1_out[7:6]}),  // Shift by 2
      .sel(ctrl[1]),
      .out(out)
    );

    // If ctrl[2] is high, perform an additional shift by 4 positions
    always @(*) begin
        if (ctrl[2]) begin
            out = {out[3:0], out[7:4]};
        end
    end
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