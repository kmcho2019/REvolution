module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout
);
    integer i;
    reg [8:0] c;
    reg [7:0] s;

    always @(*) begin
        c[0] = Cin;
        for (i = 0; i < 8; i = i + 1) begin
            s[i] = a[i] ^ b[i] ^ c[i];
            c[i+1] = (a[i] & b[i]) | ((a[i] ^ b[i]) & c[i]);
        end
    end

    assign sum = s;
    assign Cout = c[8];
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    adder_8bit lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(carry_mid)
    );

    adder_8bit upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule