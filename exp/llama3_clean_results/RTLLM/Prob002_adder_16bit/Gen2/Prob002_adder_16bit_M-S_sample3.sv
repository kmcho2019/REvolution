// 1-bit full adder module
module adder_1bit(
    input a,
    input b,
    input Cin,
    output y,
    output Co
);
    
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    wire [15:0] carry;
    
    // Instantiate 16 1-bit adders
    generate
        for (genvar i = 0; i < 16; i++) begin
            if (i == 0) begin
                adder_1bit adder_bit(
                   .a(a[i]),
                   .b(b[i]),
                   .Cin(Cin),
                   .y(y[i]),
                   .Co(carry[i])
                );
            end else begin
                adder_1bit adder_bit(
                   .a(a[i]),
                   .b(b[i]),
                   .Cin(carry[i-1]),
                   .y(y[i]),
                   .Co(carry[i])
                );
            end
        end
    endgenerate
    
    // Assign carry-out
    assign Co = carry[15];
endmodule