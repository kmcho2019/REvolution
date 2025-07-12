module FourBitAdder(
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);
    wire [4:0] c;
    assign c[0] = cin;
    genvar i;
    generate
        for(i=0; i<4; i=i+1) begin : bit_add
            assign sum[i] = a[i] ^ b[i] ^ c[i];
            assign c[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
        end
    endgenerate
    assign cout = c[4];
endmodule

module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire c4; // carry out from lower 4 bits

    // Lower 4 bits addition
    wire [3:0] sum_lower;
    FourBitAdder lower_adder(
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(sum_lower),
        .cout(c4)
    );

    // Upper 4 bits addition assuming carry_in = 0
    wire [3:0] sum_upper_c0;
    wire       cout_c0;
    FourBitAdder upper_adder_c0(
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b0),
        .sum(sum_upper_c0),
        .cout(cout_c0)
    );

    // Upper 4 bits addition assuming carry_in = 1
    wire [3:0] sum_upper_c1;
    wire       cout_c1;
    FourBitAdder upper_adder_c1(
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b1),
        .sum(sum_upper_c1),
        .cout(cout_c1)
    );

    // Select final upper sum and carry based on c4
    wire [3:0] sum_upper;
    wire       cout_upper;
    assign sum_upper = c4 ? sum_upper_c1 : sum_upper_c0;
    assign cout_upper = c4 ? cout_c1 : cout_c0;

    // Combine results
    assign s = {sum_upper, sum_lower};

    // Overflow: carry into MSB (bit 7) is c4 from lower block, carry out from MSB is cout_upper
    assign overflow = c4 ^ cout_upper;

endmodule