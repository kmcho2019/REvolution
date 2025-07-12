module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    // Efficient ripple-carry implementation
    wire [8:0] carry;
    assign carry[0] = cin;
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_slice
            assign carry[i+1] = (a[i] & b[i]) | ((a[i] | b[i]) & carry[i];
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
        end
    endgenerate
    
    assign cout = carry[8];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;
    wire [7:0] sum_upper0, sum_upper1;
    
    // Lower 8-bit (ripple-carry)
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_middle)
    );
    
    // Upper 8-bit (carry-select)
    // Compute both possible sums in parallel
    adder_8bit upper_adder0 (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(1'b0),
        .sum(sum_upper0),
        .cout() // unused
    );
    
    adder_8bit upper_adder1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(1'b1),
        .sum(sum_upper1),
        .cout(Co)
    );
    
    // Select correct upper sum based on lower carry
    assign y[15:8] = carry_middle ? sum_upper1 : sum_upper0;
endmodule