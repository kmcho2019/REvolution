// Parameterized XOR tree module using built-in reduction XOR operator
module XorTree #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] in,
    output             out
);
    assign out = ^in;  // built-in reduction XOR for even parity
endmodule

// Top-level module to compute even parity of 8-bit input
module TopModule (
    input  [7:0] in,
    output       parity
);
    XorTree #(.WIDTH(8)) parity_calc (
        .in(in),
        .out(parity)
    );
endmodule

// Simple testbench for TopModule parity calculation
module tb_TopModule;
    reg  [7:0] in;
    wire       parity;

    TopModule dut (
        .in(in),
        .parity(parity)
    );

    integer i;

    initial begin
        $display("Time\tInput       Parity");
        for (i = 0; i < 256; i = i + 1) begin
            in = i[7:0];
            #1; // wait for combinational output to settle
            $display("%0t\t%b %b %b", $time, in, parity, (^in)); // parity vs expected
            if (parity !== (^in)) begin
                $display("Mismatch at input %b", in);
                $stop;
            end
        end
        $display("All parity outputs matched expected values.");
        $finish;
    end
endmodule