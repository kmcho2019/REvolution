// 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign Co = (a[7] & b[7]) | (a[7] & (a[6] ^ b[6] ^ (a[5] ^ b[5] ^ (a[4] ^ b[4] ^ (a[3] ^ b[3] ^ (a[2] ^ b[2] ^ (a[1] ^ b[1] ^ (a[0] ^ b[0] ^ Cin))))))) | (b[7] & (a[6] ^ b[6] ^ (a[5] ^ b[5] ^ (a[4] ^ b[4] ^ (a[3] ^ b[3] ^ (a[2] ^ b[2] ^ (a[1] ^ b[1] ^ (a[0] ^ b[0] ^ Cin)))))));
    
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign y[i] = a[i] ^ b[i] ^ ((a[i-1] & b[i-1]) | (a[i-1] & (a[i-2] ^ b[i-2] ^ (a[i-3] ^ b[i-3] ^ (a[i-4] ^ b[i-4] ^ (a[i-5] ^ b[i-5] ^ (a[i-6] ^ b[i-6] ^ (a[i-7] ^ b[i-7] ^ Cin))))) | (b[i-1] & (a[i-2] ^ b[i-2] ^ (a[i-3] ^ b[i-3] ^ (a[i-4] ^ b[i-4] ^ (a[i-5] ^ b[i-5] ^ (a[i-6] ^ b[i-6] ^ (a[i-7] ^ b[i-7] ^ Cin))))));
        end
    endgenerate
endmodule

// 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire C1;
    
    // Instantiate two 8-bit adders
    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(C1)
    );
    
    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(C1),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule