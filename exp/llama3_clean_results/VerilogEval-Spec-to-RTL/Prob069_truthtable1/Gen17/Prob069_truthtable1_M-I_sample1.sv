module TopModule(
    input x3,
    input x2,
    input x1,
    output reg f
);

always @(*)
begin
    // Implementing the logic derived from Karnaugh map reduction
    // The current implementation is already optimized, but ensuring proper input handling is key.
    f = (~x3 & x2) | (x3 & x1);
end

endmodule

// Example of a simple testbench for verification
module testbench;
    reg x3, x2, x1;
    wire f;

    TopModule uut(.x3(x3), .x2(x2), .x1(x1), .f(f));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);

        // Test all possible input combinations
        x3 = 0; x2 = 0; x1 = 0; #10;
        x3 = 0; x2 = 0; x1 = 1; #10;
        x3 = 0; x2 = 1; x1 = 0; #10;
        x3 = 0; x2 = 1; x1 = 1; #10;
        x3 = 1; x2 = 0; x1 = 0; #10;
        x3 = 1; x2 = 0; x1 = 1; #10;
        x3 = 1; x2 = 1; x1 = 0; #10;
        x3 = 1; x2 = 1; x1 = 1; #10;

        $finish;
    end
endmodule