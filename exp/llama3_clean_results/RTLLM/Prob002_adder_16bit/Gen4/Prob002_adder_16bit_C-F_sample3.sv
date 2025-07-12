// 8-bit full adder module optimized for PPA
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    
    wire [7:0] sum;
    wire [7:0] carry;
    
    // Calculate sum and carry for each bit using a generate block
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

// 16-bit full adder module using two optimized 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    wire C1;
    
    // Instantiate two optimized 8-bit adders
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