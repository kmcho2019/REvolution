module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r = 0,
    output reg zero,
    output reg carry = 0,
    output reg negative = 0,
    output reg overflow = 0,
    output reg flag = 0
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

    // Operation classification
    wire is_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_shift = (aluc >= SLL && aluc <= SRAV);
    wire is_logic = (aluc >= AND && aluc <= NOR);
    wire is_comp = (aluc == SLT || aluc == SLTU);
    
    // Shared arithmetic unit (carry-select adder)
    wire [31:0] arith_res;
    wire do_sub = (aluc == SUB || aluc == SUBU);
    wire is_signed = (aluc == ADD || aluc == SUB);
    
    // 16-bit carry-select adder implementation
    wire [15:0] sum_lo, sum_hi0, sum_hi1;
    wire carry_lo, carry_hi0, carry_hi1;
    
    // Lower 16 bits (ripple carry)
    assign {carry_lo, sum_lo} = do_sub ? 
        {1'b0, a[15:0]} - {1'b0, b[15:0]} : 
        {1'b0, a[15:0]} + {1'b0, b[15:0]};
    
    // Upper 16 bits (carry-select)
    assign {carry_hi0, sum_hi0} = {1'b0, a[31:16]} + {1'b0, b[31:16]};
    assign {carry_hi1, sum_hi1} = {1'b0, a[31:16]} + {1'b0, b[31:16]} + 16'd1;
    
    assign arith_res = {carry_lo ? sum_hi1 : sum_hi0, sum_lo};
    assign carry_out = carry_lo ? carry_hi1 : carry_hi0;

    // Hierarchical barrel shifter (4-stage)
    wire [4:0] shift_amt = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0];
    wire [31:0] shift_stage1 = (shift_amt[4]) ? {16'b0, b[31:16]} : b;
    wire [31:0] shift_stage2 = (shift_amt[3]) ? {8'b0, shift_stage1[31:8]} : shift_stage1;
    wire [31:0] shift_stage3 = (shift_amt[2]) ? {4'b0, shift_stage2[31:4]} : shift_stage2;
    wire [31:0] shift_stage4 = (shift_amt[1]) ? {2'b0, shift_stage3[31:2]} : shift_stage3;
    wire [31:0] shift_base = (shift_amt[0]) ? {1'b0, shift_stage4[31:1]} : shift_stage4;
    
    wire [31:0] shift_res = 
        (aluc[1:0] == 2'b00) ? (b << shift_amt) :  // SLL/SLLV
        (aluc[1:0] == 2'b10) ? shift_base :        // SRL/SRLV
        {32{shift_base[31]}} | shift_base;         // SRA/SRAV (sign extend)

    // Shared comparator for SLT/SLTU
    wire comp_result;
    assign comp_result = (aluc == SLT) ? 
        ($signed(a) < $signed(b)) : 
        (a < b);

    always @(*) begin
        // Default outputs
        r = 0;
        carry = 0;
        overflow = 0;
        flag = 0;
        negative = 0;
        zero = 0;

        // Operation selection with enable signals
        case (aluc)
            ADD, ADDU, SUB, SUBU: begin
                r = arith_res;
                carry = carry_out;
                if (is_signed) begin
                    overflow = (a[31] == b[31] ^ do_sub) && (r[31] != a[31]);
                end
            end
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            SLT, SLTU: begin 
                r = 0; 
                flag = comp_result; 
            end
            SLL, SLLV, SRL, SRLV, SRA, SRAV: r = shift_res;
            LUI:  r = {b[15:0], 16'b0};
            default: r = 0;
        endcase

        // Conditional flag updates
        negative = r[31];
        zero = ~(|r);
        
        // Only update flags when needed
        if (!is_logic && aluc != LUI) begin
            {carry, overflow} = {carry_out, 
                                (is_signed && (a[31] == b[31] ^ do_sub) && (r[31] != a[31]))};
        end
    end

endmodule