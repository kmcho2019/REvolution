// Full Adder Module
module full_adder(
    input  logic a, 
    input  logic b, 
    input  logic cin, 
    output logic sum, 
    output logic cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// 8-bit Adder Module
module adder_8bit(
    input  logic [7:0] a, 
    input  logic [7:0] b, 
    input  logic cin, 
    output logic [7:0] sum, 
    output logic cout
);

    wire [6:0] carries;

    full_adder fa0(
        .a(a[0]), 
        .b(b[0]), 
        .cin(cin), 
        .sum(sum[0]), 
        .cout(carries[0])
    );

    full_adder fa1(
        .a(a[1]), 
        .b(b[1]), 
        .cin(carries[0]), 
        .sum(sum[1]), 
        .cout(carries[1])
    );

    full_adder fa2(
        .a(a[2]), 
        .b(b[2]), 
        .cin(carries[1]), 
        .sum(sum[2]), 
        .cout(carries[2])
    );

    full_adder fa3(
        .a(a[3]), 
        .b(b[3]), 
        .cin(carries[2]), 
        .sum(sum[3]), 
        .cout(carries[3])
    );

    full_adder fa4(
        .a(a[4]), 
        .b(b[4]), 
        .cin(carries[3]), 
        .sum(sum[4]), 
        .cout(carries[4])
    );

    full_adder fa5(
        .a(a[5]), 
        .b(b[5]), 
        .cin(carries[4]), 
        .sum(sum[5]), 
        .cout(carries[5])
    );

    full_adder fa6(
        .a(a[6]), 
        .b(b[6]), 
        .cin(carries[5]), 
        .sum(sum[6]), 
        .cout(carries[6])
    );

    full_adder fa7(
        .a(a[7]), 
        .b(b[7]), 
        .cin(carries[6]), 
        .sum(sum[7]), 
        .cout(cout)
    );

endmodule