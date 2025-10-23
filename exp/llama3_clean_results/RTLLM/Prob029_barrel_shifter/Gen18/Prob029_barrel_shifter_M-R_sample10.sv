// Define the barrel_shifter module
module barrel_shifter(
    input  [7:0] in,   // Input to be shifted
    input  [2:0] ctrl, // Control signal
    output [7:0] out  // Shifted output
);

    // Directly calculate the shift amount based on control bits
    assign out = in >> (ctrl[2] ? 4 : 0) >> (ctrl[1] ? 2 : 0) >> (ctrl[0] ? 1 : 0);

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
        // Initialize input and control signals
        in = 8'b11010011;
        ctrl = 3'b000; // Test no shift

        // Test all possible combinations of control bits
        for (int i = 0; i < 8; i++) begin
            ctrl = i;
            #10;
            $display("For ctrl = %b, Output: %b", ctrl, out);
        end

        // Test with different input values
        for (int i = 0; i < 256; i++) begin
            in = i;
            ctrl = 3'b111; // Test shift by 7
            #10;
            $display("For in = %b and ctrl = %b, Output: %b", in, ctrl, out);
        end

        #10;
        $finish;
    end
endmodule