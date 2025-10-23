// Define the barrel_shifter module
module barrel_shifter(
    input  [7:0] in,   // Input to be shifted
    input  [2:0] ctrl, // Control signal
    output [7:0] out  // Shifted output
);

    // Intermediate wires for stage-by-stage shifting
    wire [7:0] shift_4;
    wire [7:0] shift_2;
    wire [7:0] shift_1;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    assign shift_4 = ctrl[2] ? {in[3:0], 4'b0000} : in;

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    assign shift_2 = ctrl[1] ? {shift_4[5:0], 2'b00} : shift_4;

    // Stage 3: Shift by 1 position if ctrl[0] is high
    assign shift_1 = ctrl[0] ? {shift_2[6:0], 1'b0} : shift_2;

    // Final output
    assign out = shift_1;

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