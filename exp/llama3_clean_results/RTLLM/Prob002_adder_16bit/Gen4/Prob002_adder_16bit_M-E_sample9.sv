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

// 16-bit full adder using a linear array of 1-bit adders with dynamic carry propagation
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    wire [15:0] sum;
    wire [15:0] carry;
    
    // Instantiate 1-bit adders in a linear array
    generate
        for (genvar i = 0; i < 16; i++) begin
            if (i == 0) begin
                adder_1bit adder_bit(
                    .a(a[i]),
                    .b(b[i]),
                    .Cin(Cin),
                    .sum(sum[i]),
                    .Co(carry[i])
                );
            end else begin
                adder_1bit adder_bit(
                    .a(a[i]),
                    .b(b[i]),
                    .Cin(carry[i-1]),
                    .sum(sum[i]),
                    .Co(carry[i])
                );
            end
        end
    endgenerate
    
    // Assign output
    assign y = sum;
    assign Co = carry[15];
endmodule