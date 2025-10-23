// 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    
    assign y = a ^ b ^ {8{Cin}};
    assign Co = (a[7] & b[7]) | (a[7] & Cin) | (b[7] & Cin);
    
    // Using a loop to calculate carry for each bit
    // Note: This approach simplifies the carry calculation but may not be synthesis-friendly
    // For synthesis, the original generate block or a similar approach should be used
    // wire [7:0] carry;
    // assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);
    // for (genvar i = 1; i < 8; i++) begin
    //     assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
    // end
    
    // Simplified carry calculation, however, the above comment notes the potential synthesis issue
    // assign Co = |(a & b) | (a & {8{Cin}}) | (b & {8{Cin}});
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