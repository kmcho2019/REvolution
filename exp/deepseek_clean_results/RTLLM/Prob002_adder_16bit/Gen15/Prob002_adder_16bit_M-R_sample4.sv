module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire [8:0] carry;
    
    assign carry[0] = cin;
    
    // Generate carry using loop for better scalability
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_gen
            assign carry[i+1] = (a[i] & b[i]) | ((a[i] | b[i]) & carry[i]);
        end
    endgenerate
    
    // Compact sum calculation
    assign sum = a ^ b ^ carry[7:0];
    assign cout = carry[8];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Intermediate carry between 8-bit adders
    wire carry_intermediate;
    
    // Instantiate lower 8-bit adder
    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_intermediate)
    );
    
    // Instantiate upper 8-bit adder
    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_intermediate),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule