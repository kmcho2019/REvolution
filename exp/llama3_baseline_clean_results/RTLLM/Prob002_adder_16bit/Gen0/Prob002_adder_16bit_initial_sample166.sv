// Define the 8-bit adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    
    // Calculate the sum and carry-out
    assign {Co, y} = a + b + Cin;
endmodule

// Define the 16-bit adder module using the 8-bit adder
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    // Instantiate the 8-bit adder for lower 8 bits
    wire [7:0] lower_sum;
    wire lower_carry;
    adder_8bit lower_adder(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(lower_sum),
        .Co(lower_carry)
    );
    
    // Instantiate the 8-bit adder for upper 8 bits
    wire [7:0] upper_sum;
    adder_8bit upper_adder(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(lower_carry),
        .y(upper_sum),
        .Co(Co)
    );
    
    // Combine the results
    assign y = {upper_sum, lower_sum};
endmodule