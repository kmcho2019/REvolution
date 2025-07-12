module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Directly use control bits to determine shift amount
    assign out = in >> (ctrl[2] * 4 + ctrl[1] * 2 + ctrl[0]);

endmodule

// Testbench for comprehensive verification
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

        // Test all possible combinations of control bits
        for (int i = 0; i < 8; i++) begin
            ctrl = i;
            in = 8'b11010011;  // Test with a specific input
            #10;
            $display("Output for ctrl = %b and in = %b: %b", ctrl, in, out);

            in = 8'b10101010;  // Test with another input
            #10;
            $display("Output for ctrl = %b and in = %b: %b", ctrl, in, out);
        end

        // Additional test cases for different inputs and control signals
        in = 8'b11110000;
        ctrl = 3'b000;  // Test no shift
        #10;
        $display("Output for ctrl = %b and in = %b: %b", ctrl, in, out);

        in = 8'b11110000;
        ctrl = 3'b001;  // Test shift by 1
        #10;
        $display("Output for ctrl = %b and in = %b: %b", ctrl, in, out);

        in = 8'b11110000;
        ctrl = 3'b010;  // Test shift by 2
        #10;
        $display("Output for ctrl = %b and in = %b: %b", ctrl, in, out);

        in = 8'b11110000;
        ctrl = 3'b100;  // Test shift by 4
        #10;
        $display("Output for ctrl = %b and in = %b: %b", ctrl, in, out);

        #10;
        $finish;
    end
endmodule