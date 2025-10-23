// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Define wires for intermediate results
    wire [7:0] shift_1, shift_2, shift_4;

    // Shift by 1 position
    assign shift_1 = (ctrl[0] == 1'b1)? {in[6:0], 1'b0} : in;

    // Shift by 2 positions
    assign shift_2 = (ctrl[1] == 1'b1)? {shift_1[5:0], 2'b00} : shift_1;

    // Shift by 4 positions
    assign shift_4 = (ctrl[2] == 1'b1)? {shift_2[3:0], 4'b0000} : shift_2;

    // Assign the final output
    assign out = shift_4;

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