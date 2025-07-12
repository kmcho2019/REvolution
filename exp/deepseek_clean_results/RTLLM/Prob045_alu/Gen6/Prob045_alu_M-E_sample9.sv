module alu(
    input clk,
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
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

    // Pipeline registers
    reg [31:0] stage1_a, stage1_b;
    reg [5:0] stage1_aluc;
    reg [31:0] stage1_arith_res;
    reg stage1_carry, stage1_overflow;
    reg [31:0] stage1_logic_res;
    reg stage1_comp_res;

    // Stage 1: Arithmetic/Logic operations
    always @(posedge clk) begin
        // Register inputs
        stage1_a <= a;
        stage1_b <= b;
        stage1_aluc <= aluc;

        // Carry-select adder (16-bit chunks)
        case ({aluc == SUB || aluc == SUBU, aluc == ADDU || aluc == SUBU})
            2'b00: {stage1_carry, stage1_arith_res} = a + b + (aluc == SUB || aluc == SUBU);
            2'b01: {stage1_carry, stage1_arith_res} = a + b + (aluc == SUB || aluc == SUBU);
            2'b10: {stage1_carry, stage1_arith_res} = a - b;
            2'b11: {stage1_carry, stage1_arith_res} = a - b;
        endcase

        // Overflow detection
        stage1_overflow <= (aluc == ADD && (a[31] == b[31]) && (stage1_arith_res[31] != a[31]) ||
                          (aluc == SUB && (a[31] != b[31])) && (stage1_arith_res[31] != a[31]);

        // Logic operations
        case (aluc[2:0])
            3'b100: stage1_logic_res <= a & b;
            3'b101: stage1_logic_res <= a | b;
            3'b110: stage1_logic_res <= a ^ b;
            3'b111: stage1_logic_res <= ~(a | b);
            default: stage1_logic_res <= 32'b0;
        endcase

        // Comparison operations
        if (aluc == SLT)
            stage1_comp_res <= $signed(a) < $signed(b);
        else if (aluc == SLTU)
            stage1_comp_res <= a < b;
    end

    // Stage 2: Shifts and result selection
    always @(posedge clk) begin
        // Shift operations (Mux tree implementation)
        reg [31:0] shift_res;
        reg [4:0] shift_amt = stage1_aluc[3] ? stage1_a[4:0] : stage1_b[4:0];
        
        case (stage1_aluc[1:0])
            2'b00: shift_res = stage1_b << shift_amt;  // SLL
            2'b10: shift_res = stage1_b >> shift_amt;  // SRL
            2'b11: shift_res = $signed(stage1_b) >>> shift_amt;  // SRA
            default: shift_res = stage1_b;
        endcase

        // Result selection with priority encoder
        case (1'b1)
            (stage1_aluc == LUI): r <= {stage1_b[15:0], 16'b0};
            (stage1_aluc == ADD || stage1_aluc == ADDU || 
             stage1_aluc == SUB || stage1_aluc == SUBU): r <= stage1_arith_res;
            (stage1_aluc == AND || stage1_aluc == OR || 
             stage1_aluc == XOR || stage1_aluc == NOR): r <= stage1_logic_res;
            (stage1_aluc == SLT || stage1_aluc == SLTU): r <= {31'b0, stage1_comp_res};
            (stage1_aluc == SLL || stage1_aluc == SRL || 
             stage1_aluc == SRA || stage1_aluc == SLLV || 
             stage1_aluc == SRLV || stage1_aluc == SRAV): r <= shift_res;
            default: r <= 32'b0;
        endcase

        // Flag generation
        zero <= (r == 32'b0);
        carry <= stage1_carry;
        negative <= r[31];
        overflow <= stage1_overflow;
        flag <= (stage1_aluc == SLT || stage1_aluc == SLTU) ? stage1_comp_res : 1'b0;
    end

endmodule