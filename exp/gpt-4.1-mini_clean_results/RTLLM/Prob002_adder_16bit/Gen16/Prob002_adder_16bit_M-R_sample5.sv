module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] p; // propagate
    wire [7:0] g; // generate
    wire [8:0] carry;

    assign p = a ^ b;
    assign g = a & b;

    // Function to compute carries for 8 bits ripple carry chain
    function [8:0] calc_carry;
        input [7:0] p_in;
        input [7:0] g_in;
        input       c_in;
        integer     i;
        reg [8:0]   c;
        begin
            c[0] = c_in;
            for (i = 0; i < 8; i = i + 1) begin
                c[i+1] = g_in[i] | (p_in[i] & c[i]);
            end
            calc_carry = c;
        end
    endfunction

    assign carry = calc_carry(p, g, Cin);

    assign y = p ^ carry[7:0];
    assign Co = carry[8];
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
        .y(y[7:0]),
        .Co(carry_mid)
    );

    adder_8bit upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule