// Parameterized full adder module
module adder(
    parameter WIDTH = 8,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input Cin,
    output [WIDTH-1:0] y,
    output Co
);
    
    wire [WIDTH-1:0] sum;
    wire [WIDTH-1:0] carry;
    
    assign sum[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);
    
    generate
        for (genvar i = 1; i < WIDTH; i++) begin
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate
    
    assign y = sum;
    assign Co = carry[WIDTH-1];
endmodule

// 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    adder #(.WIDTH(8)) adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(C1)
    );
    
    adder #(.WIDTH(8)) adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(C1),
        .y(y[15:8]),
        .Co(Co)
    );
    
    wire C1;
endmodule