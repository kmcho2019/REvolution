// Simplified barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Calculate the total shift amount directly from control bits
    assign out = (in >> (ctrl[2] * 4 + ctrl[1] * 2 + ctrl[0]));

endmodule

// Simplified testbench
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
        
        // Test no shift
        in = 8'b11010011;
        ctrl = 3'b000;  
        #10;
        $display("Output (no shift): %b", out);

        // Test shifts by 1, 2, 4, and combinations
        in = 8'b11010011;
        ctrl = 3'b001;  // Shift by 1
        #10;
        $display("Output (shift by 1): %b", out);

        ctrl = 3'b010;  // Shift by 2
        #10;
        $display("Output (shift by 2): %b", out);

        ctrl = 3'b100;  // Shift by 4
        #10;
        $display("Output (shift by 4): %b", out);

        ctrl = 3'b011;  // Shift by 3 (1+2)
        #10;
        $display("Output (shift by 3): %b", out);

        ctrl = 3'b101;  // Shift by 5 (1+4)
        #10;
        $display("Output (shift by 5): %b", out);

        ctrl = 3'b110;  // Shift by 6 (2+4)
        #10;
        $display("Output (shift by 6): %b", out);

        ctrl = 3'b111;  // Shift by 7 (1+2+4)
        #10;
        $display("Output (shift by 7): %b", out);

        #10;
        $finish;
    end
endmodule