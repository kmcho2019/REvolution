// 1-bit full adder module
module adder_1bit(
    input a,
    input b,
    input Cin,
    output sum,
    output Co
);
    
    assign sum = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    
    wire [7:0] carry;
    
    // Instantiate 8 1-bit adders
    adder_1bit adder_0(
        .a(a[0]),
        .b(b[0]),
        .Cin(Cin),
        .sum(y[0]),
        .Co(carry[0])
    );
    
    generate
        for (genvar i = 1; i < 8; i++) begin
            adder_1bit adder_i(
                .a(a[i]),
                .b(b[i]),
                .Cin(carry[i-1]),
                .sum(y[i]),
                .Co(carry[i])
            );
        end
    endgenerate
    
    // Assign output carry
    assign Co = carry[7];
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