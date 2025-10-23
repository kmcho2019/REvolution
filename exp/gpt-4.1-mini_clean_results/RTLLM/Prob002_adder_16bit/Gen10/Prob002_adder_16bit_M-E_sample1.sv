module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       Cin,
    output wire [7:0] sum,
    output wire       Cout
);
    wire [7:0] c; // internal carry signals between bits

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : full_adder_chain
            if (i == 0) begin
                full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(Cin),
                    .sum(sum[i]),
                    .cout(c[i])
                );
            end else begin
                full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(c[i-1]),
                    .sum(sum[i]),
                    .cout(c[i])
                );
            end
        end
    endgenerate

    assign Cout = c[7];
endmodule

module adder_16bit (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        Cin,
    output wire [15:0] y,
    output wire        Co
);
    wire c_mid;

    adder_8bit lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(c_mid)
    );

    adder_8bit upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c_mid),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule