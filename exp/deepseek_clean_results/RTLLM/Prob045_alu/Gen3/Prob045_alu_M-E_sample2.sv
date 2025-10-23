module alu(
    input clk,          // Clock for pipelining
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

    // Pipeline stage 1 registers
    reg [31:0] a_reg, b_reg;
    reg [5:0] aluc_reg;
    reg signed [31:0] signed_a_reg, signed_b_reg;
    
    // Pre-computed results
    wire [32:0] add_res = {1'b0, a_reg} + {1'b0, b_reg};
    wire [32:0] sub_res = {1'b0, a_reg} + {1'b0, ~b_reg} + 33'b1; // Complement-and-add
    wire [31:0] and_res = a_reg & b_reg;
    wire [31:0] or_res = a_reg | b_reg;
    wire [31:0] xor_res = a_reg ^ b_reg;
    wire [31:0] nor_res = ~(a_reg | b_reg);
    wire slt_res = signed_a_reg < signed_b_reg;
    wire sltu_res = a_reg < b_reg;
    
    // Barrel shifter implementation
    wire [4:0] shift_amount = aluc_reg[3] ? a_reg[4:0] : b_reg[4:0];
    wire [31:0] sll_res = b_reg << shift_amount;
    wire [31:0] srl_res = b_reg >> shift_amount;
    wire [31:0] sra_res = $signed(b_reg) >>> shift_amount;
    wire [31:0] lui_res = {b_reg[15:0], 16'b0};
    
    // Flag computation
    wire zero_tmp;
    parallel_nor32 zero_detect(.in(r), .out(zero_tmp));
    assign zero = zero_tmp;
    assign negative = r[31];
    assign overflow = (aluc_reg == ADD && (a_reg[31] == b_reg[31]) && (r[31] != a_reg[31])) ||
                    (aluc_reg == SUB && (a_reg[31] != b_reg[31]) && (r[31] != a_reg[31]));
    assign carry = (aluc_reg == ADD || aluc_reg == ADDU) ? add_res[32] : 
                 (aluc_reg == SUB || aluc_reg == SUBU) ? sub_res[32] : 1'b0;
    assign flag = (aluc_reg == SLT) ? slt_res :
                 (aluc_reg == SLTU) ? sltu_res : 1'b0;

    // Pipeline stage 1: Register inputs and pre-compute
    always @(posedge clk) begin
        a_reg <= a;
        b_reg <= b;
        aluc_reg <= aluc;
        signed_a_reg <= a;
        signed_b_reg <= b;
    end

    // Pipeline stage 2: Select result
    always @(posedge clk) begin
        case (aluc_reg)
            ADD, ADDU: r <= add_res[31:0];
            SUB, SUBU: r <= sub_res[31:0];
            AND:  r <= and_res;
            OR:   r <= or_res;
            XOR:  r <= xor_res;
            NOR:  r <= nor_res;
            SLT:  r <= {31'b0, slt_res};
            SLTU: r <= {31'b0, sltu_res};
            SLL:  r <= sll_res;
            SRL:  r <= srl_res;
            SRA:  r <= sra_res;
            LUI:  r <= lui_res;
            default: r <= 32'b0;
        endcase
    end

endmodule

// Parallel NOR tree for zero detection
module parallel_nor32(
    input [31:0] in,
    output out
);
    wire [15:0] stage1 = ~(in[31:16] | in[15:0]);
    wire [7:0] stage2 = ~(stage1[15:8] | stage1[7:0]);
    wire [3:0] stage3 = ~(stage2[7:4] | stage2[3:0]);
    wire [1:0] stage4 = ~(stage3[3:2] | stage3[1:0]);
    assign out = ~(stage4[1] | stage4[0]);
endmodule