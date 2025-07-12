// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Define wires for intermediate results
    wire [7:0] shift_1, shift_2, shift_4, shift_3, shift_5, shift_6, shift_7;

    // Pre-shift the input by all possible amounts
    assign shift_1 = {in[6:0], in[7]};  // Shift by 1 position
    assign shift_2 = {in[5:0], in[7:6]};  // Shift by 2 positions
    assign shift_3 = {in[4:0], in[7:5]};  // Shift by 3 positions (combination of 1 and 2)
    assign shift_4 = {in[3:0], in[7:4]};  // Shift by 4 positions
    assign shift_5 = {in[2:0], in[7:3]};  // Shift by 5 positions (combination of 1 and 4)
    assign shift_6 = {in[1:0], in[7:2]};  // Shift by 6 positions (combination of 2 and 4)
    assign shift_7 = {in[0], in[7:1]};  // Shift by 7 positions (combination of 1, 2, and 4)

    // Use a multiplexer to select the correct shifted version of the input
    always @(*) begin
        case (ctrl)
            3'b000: out = in;  // No shift
            3'b001: out = shift_1;  // Shift by 1 position
            3'b010: out = shift_2;  // Shift by 2 positions
            3'b011: out = shift_3;  // Shift by 3 positions
            3'b100: out = shift_4;  // Shift by 4 positions
            3'b101: out = shift_5;  // Shift by 5 positions
            3'b110: out = shift_6;  // Shift by 6 positions
            3'b111: out = shift_7;  // Shift by 7 positions
            default: out = in;  // Default to no shift
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