module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

// Stage 1: First level of 3:2 compression (85 full adders)
wire [84:0] sum1, carry1;
genvar i;
generate
    for (i = 0; i < 85; i = i + 1) begin : STAGE1
        full_adder fa (
            .a(in[i*3]),
            .b(in[i*3+1]),
            .c(in[i*3+2]),
            .sum(sum1[i]),
            .cout(carry1[i])
        );
    end
endgenerate

// Stage 2: Compress sum1 and carry1 (170 bits total)
// Need to pad to make divisible by 3 (next multiple is 171)
wire [56:0] sum2, carry2;
generate
    for (i = 0; i < 57; i = i + 1) begin : STAGE2
        if (i < 56) begin
            full_adder fa (
                .a(i*3 < 85 ? sum1[i*3] : 1'b0),
                .b(i*3+1 < 85 ? sum1[i*3+1] : 1'b0),
                .c(i*3+2 < 85 ? sum1[i*3+2] : 1'b0),
                .sum(sum2[i]),
                .cout(carry2[i])
            );
        end else begin
            // Handle remaining bits (2 bits)
            assign sum2[i] = (i*3 < 85 ? sum1[i*3] : 1'b0) ^ 
                            (i*3+1 < 85 ? sum1[i*3+1] : 1'b0);
            assign carry2[i] = (i*3 < 85 ? sum1[i*3] : 1'b0) & 
                              (i*3+1 < 85 ? sum1[i*3+1] : 1'b0);
        end
    end
    
    // Also compress carry1 (same structure)
    wire [56:0] sum2_c, carry2_c;
    for (i = 0; i < 57; i = i + 1) begin : STAGE2_CARRY
        if (i < 56) begin
            full_adder fa (
                .a(i*3 < 85 ? carry1[i*3] : 1'b0),
                .b(i*3+1 < 85 ? carry1[i*3+1] : 1'b0),
                .c(i*3+2 < 85 ? carry1[i*3+2] : 1'b0),
                .sum(sum2_c[i]),
                .cout(carry2_c[i])
            );
        end else begin
            assign sum2_c[i] = (i*3 < 85 ? carry1[i*3] : 1'b0) ^ 
                              (i*3+1 < 85 ? carry1[i*3+1] : 1'b0);
            assign carry2_c[i] = (i*3 < 85 ? carry1[i*3] : 1'b0) & 
                                (i*3+1 < 85 ? carry1[i*3+1] : 1'b0);
        end
    end
endgenerate

// Combine intermediate results
wire [113:0] stage2_sum = {sum2_c, sum2};
wire [113:0] stage2_carry = {carry2_c, carry2} << 1;

// Final addition
assign out = stage2_sum + stage2_carry;

endmodule

// Full adder module
module full_adder (
    input a, b, c,
    output sum, cout
);
    assign sum = a ^ b ^ c;
    assign cout = (a & b) | (a & c) | (b & c);
endmodule