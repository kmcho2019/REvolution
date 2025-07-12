module NBitCLAAdder #(
    parameter WIDTH = 8
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              cin,
    output [WIDTH-1:0] sum,
    output [WIDTH:0]   carry  // carry[0]=cin, carry[WIDTH]=cout
);
    wire [WIDTH-1:0] p = a ^ b; // propagate
    wire [WIDTH-1:0] g = a & b; // generate

    reg [WIDTH:0] c;

    integer i;
    always @(*) begin
        c[0] = cin;
        for (i = 0; i < WIDTH; i = i + 1) begin
            c[i+1] = g[i] | (p[i] & c[i]);
        end
    end

    assign carry = c;
    assign sum = p ^ c[WIDTH-1:0];

endmodule


module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] carry;

    NBitCLAAdder #(.WIDTH(8)) cla_adder (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(s),
        .carry(carry)
    );

    // Overflow detection: XOR of carry into MSB (bit 7) and carry out of MSB (bit 8)
    assign overflow = carry[7] ^ carry[8];

endmodule