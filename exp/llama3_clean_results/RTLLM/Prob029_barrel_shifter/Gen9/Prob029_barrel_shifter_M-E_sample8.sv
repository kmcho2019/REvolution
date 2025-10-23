// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Calculate the actual shift amount based on the control signal
    wire [2:0] shift_amount = (ctrl[2] ? 4 : 0) + (ctrl[1] ? 2 : 0) + (ctrl[0] ? 1 : 0);

    // Perform the shift operation
    wire [7:0] shifted_out = (in << shift_amount) | (in >> (8 - shift_amount));

    // Assign the final output
    assign out = shifted_out;

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