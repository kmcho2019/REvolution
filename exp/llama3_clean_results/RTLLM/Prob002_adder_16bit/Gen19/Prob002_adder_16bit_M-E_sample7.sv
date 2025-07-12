// Define the module for a 4-bit carry-save adder (CSA)
module csa_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] sum,
    output [3:0] carry
);

    // Internal signals for sum and carry
    wire [3:0] sum_int;
    wire [3:0] carry_int;

    // Generate block for each bit of the CSA
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            // Calculate sum and carry for each bit position
            assign sum_int[i] = (a[i] ^ b[i] ^ (i == 0 ? Cin : 0));
            assign carry_int[i] = (a[i] & b[i]) | (a[i] & (i == 0 ? Cin : 0)) | (b[i] & (i == 0 ? Cin : 0));
        end
    endgenerate

    // Assign outputs
    assign sum = sum_int;
    assign carry = carry_int;

endmodule

// Define the module for a 4-bit ripple-carry adder (RCA)
module rca_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] sum,
    output Co
);

    // Internal signal for carry
    wire [3:0] carry;

    // Generate block for each bit of the RCA
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            // Calculate sum and carry for each bit position
            assign sum[i] = (a[i] ^ b[i] ^ (i == 0 ? Cin : carry[i-1]));
            assign carry[i] = (i == 0) ? (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin) :
                                  (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    // Assign Co
    assign Co = carry[3];

endmodule

// Define the module for the pipeline stage
module pipeline_stage(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] sum,
    output [3:0] carry
);

    // Instantiate a CSA
    csa_4bit csa(
        .a(a),
        .b(b),
        .Cin(Cin),
        .sum(sum),
        .carry(carry)
    );

endmodule

// Define the module for the final pipeline stage
module final_pipeline_stage(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] sum,
    output Co
);

    // Instantiate an RCA
    rca_4bit rca(
        .a(a),
        .b(b),
        .Cin(Cin),
        .sum(sum),
        .Co(Co)
    );

endmodule

// Define the module for a 16-bit full adder using pipeline architecture
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Internal signals for sum and carry
    wire [3:0] sum_stage1;
    wire [3:0] carry_stage1;
    wire [3:0] sum_stage2;
    wire [3:0] carry_stage2;
    wire [3:0] sum_stage3;
    wire [3:0] carry_stage3;

    // Instantiate pipeline stages
    pipeline_stage stage1(
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .sum(sum_stage1),
        .carry(carry_stage1)
    );

    pipeline_stage stage2(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(carry_stage1[3]),
        .sum(sum_stage2),
        .carry(carry_stage2)
    );

    pipeline_stage stage3(
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(carry_stage2[3]),
        .sum(sum_stage3),
        .carry(carry_stage3)
    );

    final_pipeline_stage stage4(
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(carry_stage3[3]),
        .sum(y[15:12]),
        .Co(Co)
    );

    // Assign outputs
    assign y[11:8] = sum_stage3;
    assign y[7:4] = sum_stage2;
    assign y[3:0] = sum_stage1;

endmodule