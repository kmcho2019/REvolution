module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

// Define a 2-bit full adder
module adder_2bit(
    input [1:0] a,
    input [1:0] b,
    input Cin,
    output [1:0] y,
    output Co
);
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign y[1] = a[1] ^ b[1];
    assign Co = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);
endmodule

// Define a carry-save adder (CSA) for 2 bits
module csa_2bit(
    input [1:0] a,
    input [1:0] b,
    input Cin,
    output [1:0] sum,
    output Co
);
    assign sum[0] = a[0] ^ b[0] ^ Cin;
    assign sum[1] = a[1] ^ b[1];
    assign Co = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);
endmodule

// First stage: Break down into 8 segments of 2 bits each
wire [1:0] seg_a [7:0];
wire [1:0] seg_b [7:0];
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign seg_a[i] = a[(i*2)+1:i*2];
        assign seg_b[i] = b[(i*2)+1:i*2];
    end
endgenerate

// Instantiate the first stage of 2-bit adders
wire [1:0] sum_0 [7:0];
wire [7:0] carry_0;
generate
    for (i = 0; i < 8; i++) begin
        adder_2bit adder_i(
            .a(seg_a[i]),
            .b(seg_b[i]),
            .Cin(Cin),
            .y(sum_0[i]),
            .Co(carry_0[i])
        );
    end
endgenerate

// Second stage: Combine sums and carries using CSA
wire [1:0] sum_1 [3:0];
wire [3:0] carry_1;
generate
    for (i = 0; i < 4; i++) begin
        csa_2bit csa_i(
            .a(sum_0[i*2]),
            .b(sum_0[i*2+1]),
            .Cin(carry_0[i*2]),
            .sum(sum_1[i]),
            .Co(carry_1[i])
        );
    end
endgenerate

// Third stage: Final combination
wire [1:0] sum_2 [1:0];
wire [1:0] carry_2;
generate
    for (i = 0; i < 2; i++) begin
        csa_2bit csa_i(
            .a(sum_1[i*2]),
            .b(sum_1[i*2+1]),
            .Cin(carry_1[i*2]),
            .sum(sum_2[i]),
            .Co(carry_2[i])
        );
    end
endgenerate

// Final stage: Produce the 16-bit sum
assign y[1:0] = sum_2[0];
assign y[3:2] = sum_2[1];
assign Co = carry_2[1];

endmodule

// Testbench for the 16-bit adder
module tb_adder_16bit;
reg [15:0] a;
reg [15:0] b;
reg Cin;
wire [15:0] y;
wire Co;

adder_16bit uut(
    .a(a),
    .b(b),
    .Cin(Cin),
    .y(y),
    .Co(Co)
);

initial begin
    a = 16'd1;
    b = 16'd2;
    Cin = 1'b0;
    #10;
    $display("a = %h, b = %h, Cin = %b, y = %h, Co = %b", a, b, Cin, y, Co);
    a = 16'd10;
    b = 16'd20;
    Cin = 1'b1;
    #10;
    $display("a = %h, b = %h, Cin = %b, y = %h, Co = %b", a, b, Cin, y, Co);
    $finish;
end

endmodule