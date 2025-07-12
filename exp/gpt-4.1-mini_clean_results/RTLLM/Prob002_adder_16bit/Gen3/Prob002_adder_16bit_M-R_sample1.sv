module full_adder (
    input  wire a,
    input  wire b,
    input  wire Cin,
    output wire sum,
    output wire Cout
);
    assign sum  = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       Cin,
    output wire [7:0] sum,
    output wire       Cout
);
    wire [7:0] c; // internal carry signals

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : fa_gen
            if (i == 0) begin
                full_adder fa_inst (
                    .a(a[i]),
                    .b(b[i]),
                    .Cin(Cin),
                    .sum(sum[i]),
                    .Cout(c[i])
                );
            end else begin
                full_adder fa_inst (
                    .a(a[i]),
                    .b(b[i]),
                    .Cin(c[i-1]),
                    .sum(sum[i]),
                    .Cout(c[i])
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
    wire c8; // Carry between the two 8-bit adders

    adder_8bit u_adder_low (
        .a   (a[7:0]),
        .b   (b[7:0]),
        .Cin (Cin),
        .sum (y[7:0]),
        .Cout(c8)
    );

    adder_8bit u_adder_high (
        .a   (a[15:8]),
        .b   (b[15:8]),
        .Cin (c8),
        .sum (y[15:8]),
        .Cout(Co)
    );
endmodule