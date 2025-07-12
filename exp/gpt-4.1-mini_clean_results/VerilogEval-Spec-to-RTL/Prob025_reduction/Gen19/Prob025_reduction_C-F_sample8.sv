// Parameterized XOR tree module using the built-in reduction XOR operator
module XorTree #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] in,
    output             out
);
    // Compute even parity via reduction XOR
    assign out = ^in;
endmodule

// Top-level module to compute even parity of 8-bit input
module TopModule (
    input  [7:0] in,
    output       parity
);
    // Instantiate parameterized XOR tree module
    XorTree #(.WIDTH(8)) parity_calc (
        .in(in),
        .out(parity)
    );
endmodule

// Testbench to exhaustively verify TopModule parity output
module tb_TopModule;
    reg  [7:0] in;
    wire       parity;

    // Instantiate DUT (device under test)
    TopModule dut (
        .in(in),
        .parity(parity)
    );

    integer i;

    initial begin
        $display("Time\tInput       Parity Expected");
        for (i = 0; i < 256; i = i + 1) begin
            in = i[7:0];
            #1; // wait for combinational logic to settle
            $display("%0t\t%b %b %b", $time, in, parity, (^in));
            if (parity !== (^in)) begin
                $display("ERROR: Mismatch at input %b", in);
                $stop;
            end
        end
        $display("All parity outputs matched expected values.");
        $finish;
    end
endmodule