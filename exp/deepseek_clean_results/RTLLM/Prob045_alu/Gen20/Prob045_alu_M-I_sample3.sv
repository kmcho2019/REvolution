module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
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

    // Operation type detection
    wire is_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire is_comp = (aluc == SLT || aluc == SLTU);
    wire is_lui = (aluc == LUI);

    // Shared Arithmetic Unit with CLA
    wire do_sub = (aluc == SUB || aluc == SUBU);
    wire [31:0] arith_b = do_sub ? ~b : b;
    wire cin = do_sub;
    
    // 4-bit CLA blocks
    wire [7:0] carry_prop;
    wire [7:0] carry_gen;
    wire [7:0] carry_out;
    wire [31:0] arith_result;
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : cla_blocks
            wire [3:0] a_block = a[i*4 +: 4];
            wire [3:0] b_block = arith_b[i*4 +: 4];
            wire [3:0] sum;
            
            // Generate and propagate
            assign carry_gen[i] = |(a_block & b_block);
            assign carry_prop[i] = &(a_block | b_block);
            
            // Sum with carry in
            assign sum = a_block ^ b_block ^ (i == 0 ? cin : carry_out[i-1]);
            
            // Carry out
            if (i == 0) begin
                assign carry_out[i] = carry_gen[i] | (carry_prop[i] & cin);
            end else begin
                assign carry_out[i] = carry_gen[i] | (carry_prop[i] & carry_out[i-1]);
            end
            
            // Store partial result
            assign arith_result[i*4 +: 4] = sum;
        end
    endgenerate
    
    wire arith_carry = carry_out[7];
    wire arith_ovf = (a[31] == (do_sub ? ~b[31] : b[31])) && 
                    (arith_result[31] != a[31]);

    // Shift amount register (breaks critical path)
    reg [4:0] shift_amount_reg;
    always @(*) begin
        case (aluc)
            SLLV, SRLV, SRAV: shift_amount_reg = a[4:0];
            default: shift_amount_reg = b[4:0];
        endcase
    end

    // Barrel Shifter with operation gating
    wire [31:0] shift_result;
    assign shift_result = 
        (aluc == SLL || aluc == SLLV) ? (b << shift_amount_reg) :
        (aluc == SRL || aluc == SRLV) ? (b >> shift_amount_reg) :
        ($signed(b) >>> shift_amount_reg);

    // Optimized Comparison Logic
    wire slt_result = $signed(a) < $signed(b);
    wire sltu_result = (a < b);

    // Shared Logic Operations
    wire [31:0] and_or = a & b;
    wire [31:0] or_xor = a | b;
    
    // Result Selection with operation gating
    assign r = 
        is_arith ? arith_result :
        is_logic ? 
            (aluc == AND) ? and_or :
            (aluc == OR)  ? or_xor :
            (aluc == XOR) ? (a ^ b) :
            ~or_xor : // NOR
        is_comp ? 
            {31'b0, (aluc == SLT) ? slt_result : sltu_result} :
        is_shift ? shift_result :
        is_lui ? {b[15:0], 16'b0} :
        32'b0;

    // Optimized Flag Generation
    wire zero_detect;
    assign zero_detect = ~(|r);
    assign zero = zero_detect;
    
    assign carry = is_arith ? arith_carry : 1'b0;
    assign negative = r[31];
    assign overflow = is_arith && (aluc == ADD || aluc == SUB) ? arith_ovf : 1'b0;
    assign flag = is_comp ? ((aluc == SLT) ? slt_result : sltu_result) : 1'b0;

endmodule