// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);
    assign out = (ctrl[2]) ? ({in[3:0], 4'b0000}) : in;
    assign out = (ctrl[1] && !ctrl[2]) ? ({out[5:0], 2'b00}) : (ctrl[2]) ? out : in;
    assign out = (ctrl[0] && !(ctrl[2] || ctrl[1])) ? ({out[6:0], out[7]}) : (ctrl[2] || ctrl[1]) ? out : in;
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
        ctrl = 3'b011;  // Test shift by 1 and 2
        #10;
        $display("Output (shift by 1 and 2): %b", out);

        in = 8'b11010011;
        ctrl = 3'b101;  // Test shift by 1 and 4
        #10;
        $display("Output (shift by 1 and 4): %b", out);

        in = 8'b11010011;
        ctrl = 3'b110;  // Test shift by 2 and 4
        #10;
        $display("Output (shift by 2 and 4): %b", out);

        in = 8'b11010011;
        ctrl = 3'b111;  // Test shift by 1, 2, and 4
        #10;
        $display("Output (shift by 1, 2, and 4): %b", out);
    end
endmodule