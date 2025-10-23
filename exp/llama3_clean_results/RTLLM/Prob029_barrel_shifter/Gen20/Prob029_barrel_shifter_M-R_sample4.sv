// Define the mux2X1 submodule
module mux2X1(
    input [7:0] a,  // First input
    input [7:0] b,  // Second input
    input sel,      // Select signal
    output [7:0] out  // Output
);
    assign out = sel ? b : a;
endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Intermediate wires for multiplexer outputs
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;

    // Stage 1: Shift by 1 position if ctrl[0] is high
    mux2X1 stage1_mux(
        .a(in),
        .b(in >> 1),
        .sel(ctrl[0]),
        .out(stage1_out)
    );

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage2_mux(
        .a(stage1_out),
        .b(stage1_out >> 2),
        .sel(ctrl[1]),
        .out(stage2_out)
    );

    // Stage 3: Shift by 4 positions if ctrl[2] is high
    mux2X1 stage3_mux(
        .a(stage2_out),
        .b(stage2_out >> 4),
        .sel(ctrl[2]),
        .out(out)
    );

endmodule

// Comprehensive testbench
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

        // Additional test cases for comprehensive coverage
        in = 8'b11010011;
        ctrl = 3'b000;  // Test no shift with different input
        in = 8'b10101010;
        #10;
        $display("Output (no shift, different input): %b", out);

        // Test all possible combinations of control bits
        for (int i = 0; i < 8; i++) begin
            ctrl = i;
            #10;
            $display("Output for ctrl = %b: %b", ctrl, out);
        end

        // Test with varying inputs and control signals
        for (int i = 0; i < 256; i++) begin
            in = i;
            for (int j = 0; j < 8; j++) begin
                ctrl = j;
                #10;
                $display("Output for in = %b, ctrl = %b: %b", in, ctrl, out);
            end
        end

        #10;
        $finish;
    end
endmodule