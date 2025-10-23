// 8-bit carry-lookahead adder module
module adder_8bit_cla(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    
    wire [7:0] generate;
    wire [7:0] propagate;
    wire [7:0] sum;
    wire [7:1] carry;
    
    // Calculate generate and propagate signals
    assign generate = a & b;
    assign propagate = a | b;
    
    // Calculate carry signals
    assign carry[0] = Cin;
    assign carry[1] = generate[0] | (propagate[0] & carry[0]);
    assign carry[2] = generate[1] | (propagate[1] & carry[1]);
    assign carry[3] = generate[2] | (propagate[2] & carry[2]);
    assign carry[4] = generate[3] | (propagate[3] & carry[3]);
    assign carry[5] = generate[4] | (propagate[4] & carry[4]);
    assign carry[6] = generate[5] | (propagate[5] & carry[5]);
    assign carry[7] = generate[6] | (propagate[6] & carry[6]);
    
    // Calculate sum
    assign sum[0] = a[0] ^ b[0] ^ Cin;
    assign sum[1] = a[1] ^ b[1] ^ carry[1];
    assign sum[2] = a[2] ^ b[2] ^ carry[2];
    assign sum[3] = a[3] ^ b[3] ^ carry[3];
    assign sum[4] = a[4] ^ b[4] ^ carry[4];
    assign sum[5] = a[5] ^ b[5] ^ carry[5];
    assign sum[6] = a[6] ^ b[6] ^ carry[6];
    assign sum[7] = a[7] ^ b[7] ^ carry[7];
    
    // Assign output
    assign y = sum;
    assign Co = carry[7];
endmodule

// 16-bit full adder module using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    wire C1;
    
    // Instantiate two 8-bit adders
    adder_8bit_cla adder_lower(
       .a(a[7:0]),
       .b(b[7:0]),
       .Cin(Cin),
       .y(y[7:0]),
       .Co(C1)
    );
    
    adder_8bit_cla adder_upper(
       .a(a[15:8]),
       .b(b[15:8]),
       .Cin(C1),
       .y(y[15:8]),
       .Co(Co)
    );
endmodule