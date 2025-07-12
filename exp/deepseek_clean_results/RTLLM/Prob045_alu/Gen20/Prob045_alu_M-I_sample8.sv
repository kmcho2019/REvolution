module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);

    // Operation codes
    parameter ADD  = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB  = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND  = 6'b100100;
    parameter OR   = 6'b100101;
    parameter XOR  = 6'b100110;
    parameter NOR  = 6'b100111;
    parameter SLT  = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL  = 6'b000000;
    parameter SRL  = 6'b000010;
    parameter SRA  = 6'b000011;
    parameter SLLV = 6'b000100;
    parameter SRLV = 6'b000110;
    parameter SRAV = 6'b000111;
    parameter LUI  = 6'b001111;

    // Power control signals
    wire arith_en = |{aluc[5:4] == 2'b10, aluc == SLT, aluc == SLTU};
    wire logic_en = aluc[5:4] == 2'b10 && !aluc[3];
    wire shift_en = aluc[5:4] != 2'b10;

    // Shared Arithmetic/Comparison Unit (CLA optimized)
    wire [31:0] arith_b = (aluc == SUB || aluc == SUBU) ? ~b : b;
    wire arith_cin = (aluc == SUB || aluc == SUBU);
    
    // Carry Lookahead Adder (4-bit groups)
    wire [32:0] arith_sum;
    wire [7:0] prop, gen;
    wire [7:0] carry_grp;
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i+1) begin: cla
            wire [3:0] a_grp = a[i*4 +: 4];
            wire [3:0] b_grp = arith_b[i*4 +: 4];
            wire [3:0] sum;
            
            assign {gen[i], prop[i]} = (a_grp + b_grp + {3'b0, (i==0)?arith_cin:carry_grp[i-1]});
            assign sum = a_grp ^ b_grp ^ {3'b0, (i==0)?arith_cin:carry_grp[i-1]};
            assign arith_sum[i*4 +: 4] = sum;
            
            if (i == 0)
                assign carry_grp[i] = gen[i] | (prop[i] & arith_cin);
            else
                assign carry_grp[i] = gen[i] | (prop[i] & carry_grp[i-1]);
        end
    endgenerate
    assign arith_sum[32] = carry_grp[7];
    
    // Overflow detection
    wire ovf_add = (a[31] == b[31]) && (arith_sum[31] != a[31]);
    wire ovf_sub = (a[31] != b[31]) && (arith_sum[31] != a[31]);
    
    // Comparison results
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire slt_result = signed_a < signed_b;
    wire sltu_result = a < b;

    // Optimized Logic Unit
    wire [31:0] logic_and = a & b;
    wire [31:0] logic_or  = a | b;
    wire [31:0] logic_xor = a ^ b;
    wire [31:0] logic_nor = ~logic_or;

    // Unified Barrel Shifter
    wire [4:0] shamt = (aluc[3] && |aluc[2:1]) ? a[4:0] : b[4:0];
    wire [31:0] shift_in = (aluc == LUI) ? {16'b0, b[15:0]} : b;
    wire dir = (aluc == SRA || aluc == SRAV);
    wire arith = (aluc == SRA || aluc == SRAV);
    
    wire [31:0] shifted_val;
    barrel_shifter shifter(
        .data(shift_in),
        .shamt(shamt),
        .dir(dir),
        .arith(arith),
        .result(shifted_val)
    );
    
    // Result Selection
    always @(*) begin
        casex(aluc)
            ADD, ADDU, SUB, SUBU: r = arith_sum[31:0];
            AND: r = logic_and;
            OR:  r = logic_or;
            XOR: r = logic_xor;
            NOR: r = logic_nor;
            SLT: r = {31'b0, slt_result};
            SLTU: r = {31'b0, sltu_result};
            SLL, SLLV, SRL, SRLV, SRA, SRAV: r = shifted_val;
            LUI: r = {b[15:0], 16'b0};
            default: r = 32'b0;
        endcase
    end

    // Hierarchical Zero Detection
    wire [7:0] byte_or;
    generate
        for (i = 0; i < 4; i = i+1) begin: zero_detect
            assign byte_or[i*2 +: 2] = |r[i*8 +: 8];
        end
    endgenerate
    assign zero = ~(|byte_or);

    // Conditional Flag Generation
    assign carry = arith_en ? arith_sum[32] : 1'b0;
    assign negative = r[31];
    assign overflow = (aluc == ADD) ? ovf_add : 
                    (aluc == SUB) ? ovf_sub : 1'b0;
    assign flag = (aluc == SLT) ? slt_result :
                 (aluc == SLTU) ? sltu_result : 1'b0;

endmodule

module barrel_shifter(
    input [31:0] data,
    input [4:0] shamt,
    input dir,  // 0=left, 1=right
    input arith, // arithmetic shift
    output [31:0] result
);
    wire [31:0] stage0 = (shamt[0]) ? 
                        (dir ? {arith&data[31], data[31:1]} : {data[30:0], 1'b0}) : data;
    wire [31:0] stage1 = (shamt[1]) ? 
                        (dir ? {{2{arith&stage0[31]}}, stage0[31:2]} : {stage0[29:0], 2'b0}) : stage0;
    wire [31:0] stage2 = (shamt[2]) ? 
                        (dir ? {{4{arith&stage1[31]}}, stage1[31:4]} : {stage1[27:0], 4'b0}) : stage1;
    wire [31:0] stage3 = (shamt[3]) ? 
                        (dir ? {{8{arith&stage2[31]}}, stage2[31:8]} : {stage2[23:0], 8'b0}) : stage2;
    assign result = (shamt[4]) ? 
                   (dir ? {{16{arith&stage3[31]}}, stage3[31:16]} : {stage3[15:0], 16'b0}) : stage3;
endmodule