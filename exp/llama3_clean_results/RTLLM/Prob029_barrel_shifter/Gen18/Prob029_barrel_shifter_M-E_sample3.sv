module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Define the lookup tables for each possible shift amount
    reg [7:0] lut_1, lut_2, lut_4;
    always @(in) begin
        lut_1 <= {in[6:0], 1'b0};  // Shift by 1
        lut_2 <= {in[5:0], 2'b00};  // Shift by 2
        lut_4 <= {in[3:0], 4'b0000};  // Shift by 4
    end

    // Bitwise operation stage
    reg [7:0] stage1_out, stage2_out;
    always @(ctrl, lut_1, lut_2, lut_4) begin
        stage1_out <= (ctrl[2] == 1'b1) ? lut_4 : in;  // Shift by 4 if ctrl[2] is high
        stage2_out <= (ctrl[1] == 1'b1) ? lut_2 : stage1_out;  // Shift by 2 if ctrl[1] is high
    end

    // Final output stage
    always @(ctrl, stage2_out, lut_1) begin
        out <= (ctrl[0] == 1'b1) ? lut_1 : stage2_out;  // Shift by 1 if ctrl[0] is high
    end

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

        #10;
        $finish;
    end
endmodule