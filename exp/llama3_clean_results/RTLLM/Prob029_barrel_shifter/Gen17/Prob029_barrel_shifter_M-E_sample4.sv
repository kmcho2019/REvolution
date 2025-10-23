module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Define a lookup table (LUT) for all possible shifts
    wire [7:0] lut_out;
    always @(in, ctrl) begin
        case (ctrl)
            3'b000: lut_out = in;  // No shift
            3'b001: lut_out = {in[6:0], in[7]};  // Shift by 1
            3'b010: lut_out = {in[5:0], in[7:6]};  // Shift by 2
            3'b011: lut_out = {in[4:0], in[7:5]};  // Shift by 3
            3'b100: lut_out = {in[3:0], in[7:4]};  // Shift by 4
            3'b101: lut_out = {in[2:0], in[7:3]};  // Shift by 5
            3'b110: lut_out = {in[1:0], in[7:2]};  // Shift by 6
            3'b111: lut_out = {in[0], in[7:1]};  // Shift by 7
            default: lut_out = in;  // Default to no shift
        endcase
    end

    // Output the shifted value
    assign out = lut_out;

endmodule

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