module lut_adder_2bit (
    input  [1:0] a,
    input  [1:0] b,
    output [1:0] sum
);

    // LUT for 2-bit addition
    always @(*) begin
        case ({a, b})
            4'b0000: sum = 2'b00;
            4'b0001: sum = 2'b01;
            4'b0010: sum = 2'b01;
            4'b0011: sum = 2'b10;
            4'b0100: sum = 2'b01;
            4'b0101: sum = 2'b10;
            4'b0110: sum = 2'b10;
            4'b0111: sum = 2'b11;
            4'b1000: sum = 2'b01;
            4'b1001: sum = 2'b10;
            4'b1010: sum = 2'b10;
            4'b1011: sum = 2'b11;
            4'b1100: sum = 2'b10;
            4'b1101: sum = 2'b11;
            4'b1110: sum = 2'b11;
            4'b1111: sum = 2'b11;
            default: sum = 2'b00;
        endcase
    end

endmodule

module lut_subtractor_2bit (
    input  [1:0] a,
    input  [1:0] b,
    output [1:0] diff
);

    // LUT for 2-bit subtraction
    always @(*) begin
        case ({a, b})
            4'b0000: diff = 2'b00;
            4'b0001: diff = 2'b11;
            4'b0010: diff = 2'b01;
            4'b0011: diff = 2'b10;
            4'b0100: diff = 2'b11;
            4'b0101: diff = 2'b10;
            4'b0110: diff = 2'b01;
            4'b0111: diff = 2'b00;
            4'b1000: diff = 2'b11;
            4'b1001: diff = 2'b10;
            4'b1010: diff = 2'b01;
            4'b1011: diff = 2'b00;
            4'b1100: diff = 2'b10;
            4'b1101: diff = 2'b01;
            4'b1110: diff = 2'b00;
            4'b1111: diff = 2'b11;
            default: diff = 2'b00;
        endcase
    end

endmodule

module hierarchical_adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] sum
);

    // Hierarchical 8-bit adder using 2-bit LUTs
    wire [3:0] sum_2bit_0;
    wire [3:0] sum_2bit_1;
    wire [3:0] sum_2bit_2;
    wire [3:0] sum_2bit_3;

    lut_adder_2bit u_lut_adder_0 (
        .a(a[1:0]),
        .b(b[1:0]),
        .sum(sum_2bit_0)
    );

    lut_adder_2bit u_lut_adder_1 (
        .a(a[3:2]),
        .b(b[3:2]),
        .sum(sum_2bit_1)
    );

    lut_adder_2bit u_lut_adder_2 (
        .a(a[5:4]),
        .b(b[5:4]),
        .sum(sum_2bit_2)
    );

    lut_adder_2bit u_lut_adder_3 (
        .a(a[7:6]),
        .b(b[7:6]),
        .sum(sum_2bit_3)
    );

    assign sum = {sum_2bit_3, sum_2bit_2, sum_2bit_1, sum_2bit_0};

endmodule

module hierarchical_subtractor_8bit (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] diff
);

    // Hierarchical 8-bit subtractor using 2-bit LUTs
    wire [3:0] diff_2bit_0;
    wire [3:0] diff_2bit_1;
    wire [3:0] diff_2bit_2;
    wire [3:0] diff_2bit_3;

    lut_subtractor_2bit u_lut_subtractor_0 (
        .a(a[1:0]),
        .b(b[1:0]),
        .diff(diff_2bit_0)
    );

    lut_subtractor_2bit u_lut_subtractor_1 (
        .a(a[3:2]),
        .b(b[3:2]),
        .diff(diff_2bit_1)
    );

    lut_subtractor_2bit u_lut_subtractor_2 (
        .a(a[5:4]),
        .b(b[5:4]),
        .diff(diff_2bit_2)
    );

    lut_subtractor_2bit u_lut_subtractor_3 (
        .a(a[7:6]),
        .b(b[7:6]),
        .diff(diff_2bit_3)
    );

    assign diff = {diff_2bit_3, diff_2bit_2, diff_2bit_1, diff_2bit_0};

endmodule

module TopModule (
    input logic do_sub,
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [7:0] out,
    output logic result_is_zero
);

    // Instantiate hierarchical adder or subtractor based on control signal
    wire [7:0] sum;
    wire [7:0] diff;

    hierarchical_adder_8bit u_adder (
        .a(a),
        .b(b),
        .sum(sum)
    );

    hierarchical_subtractor_8bit u_subtractor (
        .a(a),
        .b(b),
        .diff(diff)
    );

    assign out = do_sub ? diff : sum;

    assign result_is_zero = ~(| out);

endmodule