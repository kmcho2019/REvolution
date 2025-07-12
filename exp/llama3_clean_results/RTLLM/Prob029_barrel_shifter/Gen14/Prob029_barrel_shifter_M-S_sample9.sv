module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Directly select output bits based on the control signal
    assign out[7] = (ctrl[2] ? (in[3]) : (ctrl[1] ? in[5] : (ctrl[0] ? in[6] : in[7])));
    assign out[6] = (ctrl[2] ? (in[2]) : (ctrl[1] ? in[4] : (ctrl[0] ? in[5] : in[6])));
    assign out[5] = (ctrl[2] ? (in[1]) : (ctrl[1] ? in[3] : (ctrl[0] ? in[4] : in[5])));
    assign out[4] = (ctrl[2] ? (in[0]) : (ctrl[1] ? in[2] : (ctrl[0] ? in[3] : in[4])));
    assign out[3] = (ctrl[2] ? (in[7]) : (ctrl[1] ? in[1] : (ctrl[0] ? in[2] : in[3])));
    assign out[2] = (ctrl[2] ? (in[6]) : (ctrl[1] ? in[0] : (ctrl[0] ? in[1] : in[2])));
    assign out[1] = (ctrl[2] ? (in[5]) : (ctrl[1] ? in[7] : (ctrl[0] ? in[0] : in[1])));
    assign out[0] = (ctrl[2] ? (in[4]) : (ctrl[1] ? in[6] : (ctrl[0] ? in[7] : in[0])));

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