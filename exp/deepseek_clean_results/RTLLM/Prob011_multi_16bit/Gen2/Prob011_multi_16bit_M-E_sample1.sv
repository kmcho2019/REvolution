module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // Partial product generation
    wire [15:0] pp [15:0];
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : pp_gen
            assign pp[i] = ain & {16{bin[i]}};
        end
    endgenerate

    // Wallace tree reduction stages
    wire [31:0] stage1 [7:0];
    wire [31:0] stage2 [3:0];
    wire [31:0] stage3 [1:0];
    wire [31:0] sum, carry;

    // Stage 1: 16 -> 8 reduction
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_reduce
            compressor_4to2 c1 (
                .a(i*2 < 16 ? pp[i*2] << (i*2) : 32'b0),
                .b((i*2+1) < 16 ? pp[i*2+1] << (i*2+1) : 32'b0),
                .c((i*2+2) < 16 ? pp[i*2+2] << (i*2+2) : 32'b0),
                .d((i*2+3) < 16 ? pp[i*2+3] << (i*2+3) : 32'b0),
                .sum(stage1[i]),
                .carry()
            );
        end
    endgenerate

    // Stage 2: 8 -> 4 reduction
    generate
        for (i = 0; i < 4; i = i + 1) begin : stage2_reduce
            compressor_4to2 c2 (
                .a(stage1[i*2]),
                .b(stage1[i*2+1]),
                .c(i*2+2 < 8 ? stage1[i*2+2] : 32'b0),
                .d(i*2+3 < 8 ? stage1[i*2+3] : 32'b0),
                .sum(stage2[i]),
                .carry()
            );
        end
    endgenerate

    // Stage 3: 4 -> 2 reduction
    compressor_4to2 c3_0 (
        .a(stage2[0]),
        .b(stage2[1]),
        .c(stage2[2]),
        .d(stage2[3]),
        .sum(stage3[0]),
        .carry(stage3[1])
    );

    // Final addition
    carry_lookahead_adder_32b final_adder (
        .a(stage3[0]),
        .b(stage3[1]),
        .cin(1'b0),
        .sum(sum),
        .cout()
    );

    // Output registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            yout <= 32'b0;
        end
        else if (start) begin
            yout <= sum;
        end
    end

    // Done signal is combinatorial
    always @(*) begin
        done = start;
    end

endmodule

// 4:2 compressor module
module compressor_4to2 (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [31:0] c,
    input wire [31:0] d,
    output wire [31:0] sum,
    output wire [31:0] carry
);
    wire [31:0] s1, c1, s2, c2;
    
    // First level of full adders
    assign s1 = a ^ b ^ c;
    assign c1 = (a & b) | (a & c) | (b & c);
    
    // Second level of full adders
    assign sum = s1 ^ d ^ {c1[30:0], 1'b0};
    assign carry = (s1 & d) | (s1 & {c1[30:0], 1'b0}) | (d & {c1[30:0], 1'b0});
endmodule

// 32-bit carry lookahead adder
module carry_lookahead_adder_32b (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire cin,
    output wire [31:0] sum,
    output wire cout
);
    wire [31:0] g = a & b;
    wire [31:0] p = a | b;
    wire [31:0] c;
    
    assign c[0] = cin;
    genvar i;
    generate
        for (i = 1; i < 32; i = i + 1) begin : cla
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
        end
    endgenerate
    
    assign sum = a ^ b ^ c;
    assign cout = g[31] | (p[31] & c[31]);
endmodule