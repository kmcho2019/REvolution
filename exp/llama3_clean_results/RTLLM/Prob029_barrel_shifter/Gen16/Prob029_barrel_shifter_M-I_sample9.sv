// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Calculate the total shift amount based on the control bits
    // Since each bit in ctrl represents a shift by 1, 2, or 4 positions,
    // we can directly use the binary value of ctrl as the shift amount.
    wire [2:0] shift_amount = ctrl;

    // Perform the shift in a single operation
    assign out = in >> shift_amount;

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
        
        // Test all possible combinations of control bits
        for (int i = 0; i < 8; i++) begin
            ctrl = i;
            in = 8'b11010011;  // Test with a specific input
            #10;
            $display("Output for ctrl = %b: %b", ctrl, out);
        end

        // Additional test cases with different inputs
        in = 8'b10101010;
        for (int i = 0; i < 8; i++) begin
            ctrl = i;
            #10;
            $display("Output for ctrl = %b and different input: %b", ctrl, out);
        end

        // Test with all possible input values
        for (int j = 0; j < 256; j++) begin
            in = j;
            ctrl = 3'b000;  // Test no shift
            #10;
            $display("Output for input = %b and no shift: %b", in, out);
        end

        #10;
        $finish;
    end
endmodule