module TopModule(in, out);
    input [254:0] in;
    output [7:0] out;

    wire [15:0] count [15:0];

    // Population count for each 16-bit group
    genvar i;
    generate
        for (i = 0; i < 15; i++) begin: gen_popcount_16
            PopCount16 pop_count_16(
                .in(in[(i+1)*16-1:i*16]),
                .out(count[i])
            );
        end
        // Population count for the last 7-bit group
        PopCount7 pop_count_7(
            .in(in[254:248]),
            .out(count[15])
        );
    endgenerate

    // Adder tree to sum up the counts
    wire [15:0] sum0 [7:0];
    wire [15:0] sum1 [3:0];
    wire [15:0] sum2 [1:0];
    wire [15:0] sum3;

    // First level of adder tree
    genvar j;
    generate
        for (j = 0; j < 8; j++) begin: gen_add_16_0
            Add16 add_16_0(
                .in0(count[j*2]),
                .in1(count[j*2+1]),
                .out(sum0[j])
            );
        end
    endgenerate

    // Second level of adder tree
    generate
        for (j = 0; j < 4; j++) begin: gen_add_16_1
            Add16 add_16_1(
                .in0(sum0[j*2]),
                .in1(sum0[j*2+1]),
                .out(sum1[j])
            );
        end
    endgenerate

    // Third level of adder tree
    generate
        for (j = 0; j < 2; j++) begin: gen_add_16_2
            Add16 add_16_2(
                .in0(sum1[j*2]),
                .in1(sum1[j*2+1]),
                .out(sum2[j])
            );
        end
    endgenerate

    // Final level of adder tree
    Add16 add_16_3(
        .in0(sum2[0]),
        .in1(sum2[1]),
        .out(sum3)
    );

    // Output the result (only take the lower 8 bits)
    assign out = sum3[7:0];
endmodule

module PopCount16(in, out);
    input [15:0] in;
    output [15:0] out;

    assign out = {14'b0, in[0]} + {14'b0, in[1]} + {14'b0, in[2]} + {14'b0, in[3]} +
                 {14'b0, in[4]} + {14'b0, in[5]} + {14'b0, in[6]} + {14'b0, in[7]} +
                 {14'b0, in[8]} + {14'b0, in[9]} + {14'b0, in[10]} + {14'b0, in[11]} +
                 {14'b0, in[12]} + {14'b0, in[13]} + {14'b0, in[14]} + {14'b0, in[15]};
endmodule

module PopCount7(in, out);
    input [6:0] in;
    output [15:0] out;

    assign out = {14'b0, in[0]} + {14'b0, in[1]} + {14'b0, in[2]} + {14'b0, in[3]} +
                 {14'b0, in[4]} + {14'b0, in[5]} + {14'b0, in[6]};
endmodule

module Add16(in0, in1, out);
    input [15:0] in0, in1;
    output [15:0] out;

    assign out = in0 + in1;
endmodule