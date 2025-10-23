module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Define the shift amounts for each control bit
    wire [2:0] shift_amount = (ctrl[2] << 2) + (ctrl[1] << 1) + ctrl[0];

    // Define the shift registers for each segment
    reg [7:0] shift_reg1;
    reg [7:0] shift_reg2;
    reg [7:0] shift_reg3;
    reg [7:0] shift_reg4;

    // Define the multiplexers for each output bit
    wire [7:0] mux_out1;
    wire [7:0] mux_out2;
    wire [7:0] mux_out3;
    wire [7:0] mux_out4;

    // Define the control signals for the multiplexers and shift registers
    wire [2:0] ctrl_sig1;
    wire [2:0] ctrl_sig2;
    wire [2:0] ctrl_sig3;
    wire [2:0] ctrl_sig4;

    // Assign the control signals
    assign ctrl_sig1 = (ctrl[2] == 1'b1) ? 3'b001 : 3'b000;
    assign ctrl_sig2 = (ctrl[1] == 1'b1) ? 3'b010 : 3'b000;
    assign ctrl_sig3 = (ctrl[0] == 1'b1) ? 3'b100 : 3'b000;
    assign ctrl_sig4 = 3'b000;

    // Define the shift register logic
    always @(posedge clk) begin
        shift_reg1 <= (ctrl_sig1 == 3'b001) ? in >> 4 : in;
        shift_reg2 <= (ctrl_sig2 == 3'b010) ? shift_reg1 >> 2 : shift_reg1;
        shift_reg3 <= (ctrl_sig3 == 3'b100) ? shift_reg2 >> 1 : shift_reg2;
        shift_reg4 <= shift_reg3;
    end

    // Define the multiplexer logic
    assign mux_out1 = (ctrl_sig1 == 3'b001) ? shift_reg1 : in;
    assign mux_out2 = (ctrl_sig2 == 3'b010) ? shift_reg2 : mux_out1;
    assign mux_out3 = (ctrl_sig3 == 3'b100) ? shift_reg3 : mux_out2;
    assign mux_out4 = shift_reg4;

    // Assign the output
    assign out = mux_out4;

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