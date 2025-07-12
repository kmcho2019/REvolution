// 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    
    // Calculate sum and carry for each bit
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign Co = (a[7] & b[7]) | (a[7] & y[6]) | (b[7] & y[6]);
    
    // For bits 1 to 7
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign y[i] = a[i] ^ b[i] ^ ((a[i-1] & b[i-1]) | (a[i-1] & y[i-1]) | (b[i-1] & y[i-1]));
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