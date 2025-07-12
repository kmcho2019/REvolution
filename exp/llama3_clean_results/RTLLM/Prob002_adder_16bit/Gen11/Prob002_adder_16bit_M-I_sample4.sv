// 1-bit full adder module
module adder_1bit(
    input a,
    input b,
    input Cin,
    output y,
    output Co
);
    
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 16-bit carry-lookahead adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    wire [15:0] p; // Propagate signals
    wire [15:0] g; // Generate signals
    wire [15:0] c; // Carry signals
    
    // Calculate propagate and generate signals
    for (genvar i = 0; i < 16; i++) begin
        assign p[i] = a[i] ^ b[i];
        assign g[i] = a[i] & b[i];
    end
    
    // Calculate carry signals
    assign c[0] = Cin;
    for (genvar i = 1; i < 16; i++) begin
        assign c[i] = g[i] | (p[i] & c[i-1]);
    end
    
    // Calculate sum
    for (genvar i = 0; i < 16; i++) begin
        assign y[i] = p[i] ^ c[i];
    end
    
    // Calculate carry-out
    assign Co = g[15] | (p[15] & c[15]);
endmodule