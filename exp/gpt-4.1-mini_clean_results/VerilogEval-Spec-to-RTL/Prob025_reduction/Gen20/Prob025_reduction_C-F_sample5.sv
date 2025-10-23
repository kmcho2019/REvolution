// Parameterized XOR tree module using built-in reduction XOR operator for optimal synthesis
module XorTree #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] in,
    output             out
);
    // Compute even parity as XOR of all input bits
    assign out = ^in;

    /*
    // Alternative iterative XOR implementation (for educational purposes)
    // Uncomment to use procedural logic (may affect synthesis optimization)
    // reg xor_result;
    // integer i;
    // always @(*) begin
    //     xor_result = 0;
    //     for (i = 0; i < WIDTH; i = i + 1) begin
    //         xor_result = xor_result ^ in[i];
    //     end
    // end
    // assign out = xor_result;
    */
endmodule

// Top-level module to compute even parity of 8-bit input
module TopModule (
    input  [7:0] in,
    output       parity
);
    // Instantiate parameterized XorTree module
    XorTree #(.WIDTH(8)) parity_calc (
        .in(in),
        .out(parity)
    );
endmodule

// Testbench for exhaustive verification of TopModule parity output
module tb_TopModule;
    reg  [7:0] in;
    wire       parity;

    // Instantiate device under test (DUT)
    TopModule dut (
        .in(in),
        .parity(parity)
    );

    integer i;

    initial begin
        $display("Time\tInput      Parity Expected");
        for (i = 0; i < 256; i = i + 1) begin
            in = i[7:0];
            #1; // Allow combinational logic to settle
            $display("%0t\t%b %b      %b", $time, in, parity, (^in));
            if (parity !== (^in)) begin
                $display("ERROR: Mismatch at input %b", in);
                $stop;
            end
        end
        $display("All parity outputs matched expected values.");
        $finish;
    end
endmodule