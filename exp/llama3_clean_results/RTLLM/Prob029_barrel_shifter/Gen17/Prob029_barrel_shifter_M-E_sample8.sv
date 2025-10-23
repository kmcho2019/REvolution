module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Define the lookup tables for each shift amount
    reg [7:0] lut_0 [256];
    reg [7:0] lut_1 [256];
    reg [7:0] lut_2 [256];
    reg [7:0] lut_3 [256];
    reg [7:0] lut_4 [256];
    reg [7:0] lut_5 [256];
    reg [7:0] lut_6 [256];
    reg [7:0] lut_7 [256];

    // Initialize the lookup tables
    initial begin
        for (int i = 0; i < 256; i++) begin
            lut_0[i] = i;
            lut_1[i] = (i >> 1) | (i << 7);
            lut_2[i] = (i >> 2) | (i << 6);
            lut_3[i] = (i >> 3) | (i << 5);
            lut_4[i] = (i >> 4) | (i << 4);
            lut_5[i] = (i >> 5) | (i << 3);
            lut_6[i] = (i >> 6) | (i << 2);
            lut_7[i] = (i >> 7) | (i << 1);
        end
    end

    // Hierarchical shift stage
    wire [7:0] shifted_1, shifted_2, shifted_4;
    assign shifted_1 = (ctrl[0] == 1'b1)? lut_1[in] : in;
    assign shifted_2 = (ctrl[1] == 1'b1)? lut_2[shifted_1] : shifted_1;
    assign shifted_4 = (ctrl[2] == 1'b1)? lut_4[shifted_2] : shifted_2;

    // Output selection
    assign out = shifted_4;

endmodule

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