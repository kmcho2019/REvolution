module sub_64bit (
    input clk,
    input reset,
    input [63:0] A,
    input [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

    // Pipeline registers
    reg [63:0] stage1_A, stage1_B;
    reg [63:0] stage2_diff;
    reg stage2_ovfl;

    // Carry-lookahead implementation (4x16-bit blocks)
    wire [63:0] diff;
    wire [3:0] carry_out;
    
    // Stage 1: Input registration
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_A <= 64'b0;
            stage1_B <= 64'b0;
        end else begin
            stage1_A <= A;
            stage1_B <= B;
        end
    end

    // Stage 2: Subtraction and overflow detection
    cla_subtractor_64bit sub_unit (
        .A(stage1_A),
        .B(stage1_B),
        .diff(diff),
        .carry_out(carry_out)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage2_diff <= 64'b0;
            stage2_ovfl <= 1'b0;
        end else begin
            stage2_diff <= diff;
            stage2_ovfl <= (stage1_A[63] != stage1_B[63]) && (stage1_A[63] != diff[63]);
        end
    end

    // Stage 3: Output registration
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 64'b0;
            overflow <= 1'b0;
        end else begin
            result <= stage2_diff;
            overflow <= stage2_ovfl;
        end
    end

endmodule

module cla_subtractor_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] diff,
    output [3:0] carry_out
);
    // Implement 4x16-bit carry-lookahead subtractor blocks
    // This hierarchical structure improves timing and area
    wire [15:0] diff0, diff1, diff2, diff3;
    wire cin = 1'b1; // For two's complement subtraction
    
    cla_subtractor_16bit sub0 (.A(A[15:0]), .B(B[15:0]), .cin(cin), .diff(diff0), .cout(carry_out[0]));
    cla_subtractor_16bit sub1 (.A(A[31:16]), .B(B[31:16]), .cin(carry_out[0]), .diff(diff1), .cout(carry_out[1]));
    cla_subtractor_16bit sub2 (.A(A[47:32]), .B(B[47:32]), .cin(carry_out[1]), .diff(diff2), .cout(carry_out[2]));
    cla_subtractor_16bit sub3 (.A(A[63:48]), .B(B[63:48]), .cin(carry_out[2]), .diff(diff3), .cout(carry_out[3]));
    
    assign diff = {diff3, diff2, diff1, diff0};
endmodule

module cla_subtractor_16bit (
    input [15:0] A,
    input [15:0] B,
    input cin,
    output [15:0] diff,
    output cout
);
    // 16-bit carry-lookahead subtractor implementation
    wire [15:0] B_comp = ~B;
    wire [15:0] sum;
    wire [3:0] pg, gg;
    
    // Generate and propagate terms for 4-bit blocks
    assign pg[0] = &(A[3:0]   | B_comp[3:0]);
    assign pg[1] = &(A[7:4]   | B_comp[7:4]);
    assign pg[2] = &(A[11:8]  | B_comp[11:8]);
    assign pg[3] = &(A[15:12] | B_comp[15:12]);
    
    assign gg[0] = &(A[3:0]   & B_comp[3:0]);
    assign gg[1] = &(A[7:4]   & B_comp[7:4]);
    assign gg[2] = &(A[11:8]  & B_comp[11:8]);
    assign gg[3] = &(A[15:12] & B_comp[15:12]);
    
    // Carry lookahead logic
    wire [3:0] carry;
    assign carry[0] = cin;
    assign carry[1] = gg[0] | (pg[0] & carry[0]);
    assign carry[2] = gg[1] | (pg[1] & carry[1]);
    assign carry[3] = gg[2] | (pg[2] & carry[2]);
    assign cout    = gg[3] | (pg[3] & carry[3]);
    
    // Final sum with carry
    assign sum = A + B_comp + {15'b0, carry[0]};
    assign diff = sum + {15'b0, cin}; // Complete the two's complement subtraction
endmodule