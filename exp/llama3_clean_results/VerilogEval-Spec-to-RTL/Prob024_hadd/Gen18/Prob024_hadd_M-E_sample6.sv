// Define the TopModule with the simplified logic expressions
module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// Simplified expression for sum using XOR operation
assign sum = a ^ b;

// Simplified expression for carry-out using AND operation
assign cout = a & b;
endmodule

// Alternative implementation using K-map derived expressions
module TopModule_KMAP(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
// K-map derived expression for sum: a XOR b
assign sum = ~(a & b) & (a | b);

// K-map derived expression for carry-out: a AND b
assign cout = a & b;
endmodule

// Testbench to verify the functionality of the TopModule
module tb_TopModule;
reg a, b;
wire sum, cout;

TopModule u_top(a, b, sum, cout);

initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
    // Test cases
    a = 0; b = 0; #10;
    a = 0; b = 1; #10;
    a = 1; b = 0; #10;
    a = 1; b = 1; #10;
    
    #10 $finish;
end
endmodule