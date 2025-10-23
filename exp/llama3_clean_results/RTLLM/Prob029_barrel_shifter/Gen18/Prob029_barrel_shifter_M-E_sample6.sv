module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Logarithmic decoder for the control signal
    wire shift_1 = ctrl[0];
    wire shift_2 = ctrl[1];
    wire shift_4 = ctrl[2];

    // Shift segments
    wire [7:0] shift1_out;
    assign shift1_out = (in >> 1) | (in << 7);

    wire [7:0] shift2_out;
    assign shift2_out = (in >> 2) | (in << 6);

    wire [7:0] shift4_out;
    assign shift4_out = (in >> 4) | (in << 4);

    // Combination logic
    wire [7:0] temp_out;
    assign temp_out = shift_1 ? shift1_out : in;

    wire [7:0] temp_out2;
    assign temp_out2 = shift_2 ? shift2_out : temp_out;

    assign out = shift_4 ? shift4_out : temp_out2;

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

        // Test with varying inputs and control signals
        for (int i = 0; i < 256; i++) begin
            in = i;
            for (int j = 0; j < 8; j++) begin
                ctrl = j;
                #10;
                $display("Output for in = %b, ctrl = %b: %b", in, ctrl, out);
            end
        end

        #10;
        $finish;
    end
endmodule