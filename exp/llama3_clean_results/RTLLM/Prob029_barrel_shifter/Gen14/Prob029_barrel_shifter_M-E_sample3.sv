module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Memory to store all possible shifts of the input
    reg [7:0] memory [0:7];

    // Initialize memory with all possible shifts of the input
    initial begin
        for (int i = 0; i < 8; i++) begin
            case (i)
                0: memory[i] = in;  // No shift
                1: memory[i] = {in[6:0], 1'b0};  // Shift by 1
                2: memory[i] = {in[5:0], 2'b00};  // Shift by 2
                3: memory[i] = {in[5:0], in[7], 1'b0};  // Shift by 3
                4: memory[i] = {in[3:0], 4'b0000};  // Shift by 4
                5: memory[i] = {in[2:0], in[7:4], 3'b000};  // Shift by 5
                6: memory[i] = {in[1:0], in[7:2], 2'b00};  // Shift by 6
                7: memory[i] = {in[0], in[7:1], 1'b0};  // Shift by 7
            endcase
        end
    end

    // The control signal directly addresses the memory
    assign out = memory[ctrl];

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