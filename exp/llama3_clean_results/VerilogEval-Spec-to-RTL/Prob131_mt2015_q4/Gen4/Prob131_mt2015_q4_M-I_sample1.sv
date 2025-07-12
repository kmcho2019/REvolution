// ModuleA implements the boolean function z = (x^y) & x
module ModuleA(x, y, z);
    input x;
    input y;
    output z;

    assign z = (x ^ y) & x;
endmodule

// ModuleB can be described by the given simulation waveform
// After analyzing the waveform, the logic for ModuleB can be derived as z = ~(x | y)
module ModuleB(x, y, z);
    input x;
    input y;
    output z;

    assign z = ~(|x | y); // Simplified implementation using bitwise OR
endmodule

// TopLevel module
module TopLevel(x, y, z);
    input x;
    input y;
    output z;

    wire a1, b1, a2, b2;

    ModuleA u_a1(x, y, a1);
    ModuleB u_b1(x, y, b1);
    ModuleA u_a2(x, y, a2);
    ModuleB u_b2(x, y, b2);

    assign z = (a1 | b1) ^ (a2 & b2);
endmodule

// Testbench for TopLevel module
module tb_TopLevel;
    reg x, y;
    wire z;

    TopLevel uut(x, y, z);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

        x = 0; y = 0;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 0; y = 0;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 0; y = 0;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 0; y = 0;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 0; y = 0;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 1; y = 0;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 1; y = 0;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 0; y = 1;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 0; y = 1;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 1; y = 1;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 1; y = 1;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 0; y = 0;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 0; y = 1;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 0; y = 1;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 1; y = 1;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 0; y = 1;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 0; y = 1;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 0; y = 1;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        x = 1; y = 0;
        #5;
        $display("x = %b, y = %b, z = %b", x, y, z);

        #10 $finish;
    end
endmodule