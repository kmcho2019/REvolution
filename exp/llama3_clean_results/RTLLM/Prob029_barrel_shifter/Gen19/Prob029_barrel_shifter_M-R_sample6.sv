// Define the barrel_shifter module
module barrel_shifter(
    input  [7:0] in,   // Input to be shifted
    input  [2:0] ctrl, // Control signal
    output [7:0] out  // Shifted output
);

    // Use a case statement to determine the shift amount
    always @(*) begin
        case (ctrl)
            3'b001: out = in >> 1;  // Shift right by 1
            3'b010: out = in >> 2;  // Shift right by 2
            3'b011: out = in >> 3;  // Shift right by 3
            3'b100: out = in >> 4;  // Shift right by 4
            3'b101: out = in >> 5;  // Shift right by 5
            3'b110: out = in >> 6;  // Shift right by 6
            3'b111: out = in >> 7;  // Shift right by 7
            default: out = in;      // No shift
        endcase
    end

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