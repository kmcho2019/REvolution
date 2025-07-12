// Carry-lookahead adder (CLA) module for 8 bits
module cla_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    
    wire [7:0] sum;
    wire [7:0] carry;
    wire [7:0] p; // propagate signal
    wire [7:0] g; // generate signal
    
    assign p[0] = a[0] ^ b[0];
    assign g[0] = a[0] & b[0];
    
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign p[i] = a[i] ^ b[i];
            assign g[i] = a[i] & b[i];
        end
    endgenerate
    
    // Calculate carry signals using carry-lookahead logic
    assign carry[0] = Cin;
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign carry[i] = g[i-1] | (p[i-1] & carry[i-1]);
        end
    endgenerate
    
    // Calculate sum signals
    assign sum[0] = a[0] ^ b[0] ^ Cin;
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
        end
    endgenerate
    
    // Assign output
    assign y = sum;
    assign Co = g[7] | (p[7] & carry[7]);
endmodule

// Ripple-carry adder (RCA) module for 8 bits
module rca_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    
    wire [7:0] sum;
    wire [7:0] carry;
    
    assign sum[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);
    
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate
    
    // Assign output
    assign y = sum;
    assign Co = carry[7];
endmodule

// 16-bit full adder module using CLA and RCA
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    wire C1;
    
    // Instantiate CLA for lower 8 bits
    cla_8bit cla_lower(
     .a(a[7:0]),
     .b(b[7:0]),
     .Cin(Cin),
     .y(y[7:0]),
     .Co(C1)
    );
    
    // Instantiate RCA for upper 8 bits
    rca_8bit rca_upper(
     .a(a[15:8]),
     .b(b[15:8]),
     .Cin(C1),
     .y(y[15:8]),
     .Co(Co)
    );
endmodule