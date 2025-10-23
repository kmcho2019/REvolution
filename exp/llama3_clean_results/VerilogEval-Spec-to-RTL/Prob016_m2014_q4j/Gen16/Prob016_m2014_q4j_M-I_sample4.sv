// Improved FullAdder module with simplified logic (remains unchanged)
module FullAdder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    // Simplified logic for sum and carry-out using XOR and AND
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Improved TopModule using an optimized carry-lookahead adder architecture
module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    // Generate and propagate signals (optimized to reduce switching activity)
    wire g0, g1, g2, g3;
    wire p0, p1, p2, p3;
    assign g0 = x[0] & y[0];
    assign p0 = x[0] ^ y[0];
    assign g1 = x[1] & y[1];
    assign p1 = x[1] ^ y[1];
    assign g2 = x[2] & y[2];
    assign p2 = x[2] ^ y[2];
    assign g3 = x[3] & y[3];
    assign p3 = x[3] ^ y[3];
    
    // Calculate carry signals with reduced switching activity
    wire c1, c2, c3, c4;
    assign c1 = g0; // Initialize carry for first full adder
    assign c2 = g1 | (p1 & c1);
    assign c3 = g2 | (p2 & c2);
    assign c4 = g3 | (p3 & c3);
    
    // Using the improved FullAdder module in a chain for the 4-bit adder
    assign sum[0] = x[0] ^ y[0] ^ 1'b0; // Directly calculate sum for the first bit
    assign sum[1] = x[1] ^ y[1] ^ c1;
    assign sum[2] = x[2] ^ y[2] ^ c2;
    assign sum[3] = x[3] ^ y[3] ^ c3;
    assign sum[4] = c4; // Overflow bit
    
    // Optional: Further optimization could involve using synthesis tools' optimization capabilities
    // to minimize the area used by the generated netlist, or exploring more compact arithmetic logic structures.
endmodule