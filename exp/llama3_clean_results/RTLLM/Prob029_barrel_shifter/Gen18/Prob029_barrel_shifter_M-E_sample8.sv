module hierarchical_barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_out;
    assign stage1_out[0] = ctrl[2] ? (in[4] == 1'b1) ? 1'b1 : 1'b0 : in[0];
    assign stage1_out[1] = ctrl[2] ? (in[5] == 1'b1) ? 1'b1 : 1'b0 : in[1];
    assign stage1_out[2] = ctrl[2] ? (in[6] == 1'b1) ? 1'b1 : 1'b0 : in[2];
    assign stage1_out[3] = ctrl[2] ? (in[7] == 1'b1) ? 1'b1 : 1'b0 : in[3];
    assign stage1_out[4] = ctrl[2] ? (in[0] == 1'b1) ? 1'b1 : 1'b0 : in[4];
    assign stage1_out[5] = ctrl[2] ? (in[1] == 1'b1) ? 1'b1 : 1'b0 : in[5];
    assign stage1_out[6] = ctrl[2] ? (in[2] == 1'b1) ? 1'b1 : 1'b0 : in[6];
    assign stage1_out[7] = ctrl[2] ? (in[3] == 1'b1) ? 1'b1 : 1'b0 : in[7];

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_out;
    assign stage2_out[0] = ctrl[1] ? stage1_out[2] : stage1_out[0];
    assign stage2_out[1] = ctrl[1] ? stage1_out[3] : stage1_out[1];
    assign stage2_out[2] = ctrl[1] ? stage1_out[4] : stage1_out[2];
    assign stage2_out[3] = ctrl[1] ? stage1_out[5] : stage1_out[3];
    assign stage2_out[4] = ctrl[1] ? stage1_out[6] : stage1_out[4];
    assign stage2_out[5] = ctrl[1] ? stage1_out[7] : stage1_out[5];
    assign stage2_out[6] = ctrl[1] ? stage1_out[0] : stage1_out[6];
    assign stage2_out[7] = ctrl[1] ? stage1_out[1] : stage1_out[7];

    // Stage 3: Shift by 1 position if ctrl[0] is high
    assign out[0] = ctrl[0] ? stage2_out[1] : stage2_out[0];
    assign out[1] = ctrl[0] ? stage2_out[2] : stage2_out[1];
    assign out[2] = ctrl[0] ? stage2_out[3] : stage2_out[2];
    assign out[3] = ctrl[0] ? stage2_out[4] : stage2_out[3];
    assign out[4] = ctrl[0] ? stage2_out[5] : stage2_out[4];
    assign out[5] = ctrl[0] ? stage2_out[6] : stage2_out[5];
    assign out[6] = ctrl[0] ? stage2_out[7] : stage2_out[6];
    assign out[7] = ctrl[0] ? stage2_out[0] : stage2_out[7];

endmodule

module hierarchical_barrel_shifter_testbench;
    reg [7:0] in;
    reg [2:0] ctrl;
    wire [7:0] out;

    hierarchical_barrel_shifter uut (
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

        $finish;
    end
endmodule