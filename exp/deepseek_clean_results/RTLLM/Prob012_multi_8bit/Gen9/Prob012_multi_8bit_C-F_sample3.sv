module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate conditional partial products with clean structure
    wire [15:0] pp [0:7];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            assign pp[i] = B[i] ? ({8'b0, A} << i) : 16'b0;
        end
    endgenerate

    // First level: 4:2 compressor (more efficient than 3:2 CSA)
    wire [15:0] sum1, carry1;
    wire [15:0] cout1;
    assign {cout1, sum1} = pp[0] + pp[1] + pp[2] + pp[3];
    assign carry1 = cout1 << 1;

    wire [15:0] sum2, carry2;
    wire [15:0] cout2;
    assign {cout2, sum2} = pp[4] + pp[5] + pp[6] + pp[7];
    assign carry2 = cout2 << 1;

    // Second level: Balanced adder tree with carry-save
    wire [15:0] sum3 = sum1 + carry1;
    wire [15:0] sum4 = sum2 + carry2;

    // Final addition with optimized adder
    assign product = sum3 + sum4;

endmodule