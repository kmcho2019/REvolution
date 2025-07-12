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

// Define the module parameters
parameter ADD = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB = 6'b100010;
parameter SUBU = 6'b100011;
parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;
parameter SLT = 6'b101010;
parameter SLTU = 6'b101011;
parameter SLL = 6'b000000;
parameter SRL = 6'b000010;
parameter SRA = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI = 6'b001111;

// Define the module signals
wire [31:0] am_result;
wire [31:0] lm_result;
wire [31:0] sm_result;
wire [31:0] cm_result;
wire zero_am;
wire zero_lm;
wire zero_sm;
wire zero_cm;
wire carry_am;
wire carry_lm;
wire carry_sm;
wire carry_cm;
wire negative_am;
wire negative_lm;
wire negative_sm;
wire negative_cm;
wire overflow_am;
wire overflow_lm;
wire overflow_sm;
wire overflow_cm;
wire flag_am;
wire flag_lm;
wire flag_sm;
wire flag_cm;

// Instantiate the arithmetic module
arithmetic_module am(
   .a(a),
   .b(b),
   .aluc(aluc),
   .result(am_result),
   .zero(zero_am),
   .carry(carry_am),
   .negative(negative_am),
   .overflow(overflow_am),
   .flag(flag_am)
);

// Instantiate the logical module
logical_module lm(
   .a(a),
   .b(b),
   .aluc(aluc),
   .result(lm_result),
   .zero(zero_lm),
   .carry(carry_lm),
   .negative(negative_lm),
   .overflow(overflow_lm),
   .flag(flag_lm)
);

// Instantiate the shift module
shift_module sm(
   .a(a),
   .b(b),
   .aluc(aluc),
   .result(sm_result),
   .zero(zero_sm),
   .carry(carry_sm),
   .negative(negative_sm),
   .overflow(overflow_sm),
   .flag(flag_sm)
);

// Instantiate the comparison module
comparison_module cm(
   .a(a),
   .b(b),
   .aluc(aluc),
   .result(cm_result),
   .zero(zero_cm),
   .carry(carry_cm),
   .negative(negative_cm),
   .overflow(overflow_cm),
   .flag(flag_cm)
);

// Define the control module
control_module ct(
   .a(a),
   .b(b),
   .aluc(aluc),
   .am_result(am_result),
   .lm_result(lm_result),
   .sm_result(sm_result),
   .cm_result(cm_result),
   .zero(zero_am, zero_lm, zero_sm, zero_cm),
   .carry(carry_am, carry_lm, carry_sm, carry_cm),
   .negative(negative_am, negative_lm, negative_sm, negative_cm),
   .overflow(overflow_am, overflow_lm, overflow_sm, overflow_cm),
   .flag(flag_am, flag_lm, flag_sm, flag_cm),
   .r(r),
   .zero(zero),
   .carry(carry),
   .negative(negative),
   .overflow(overflow),
   .flag(flag)
);

endmodule

module arithmetic_module(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] result,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);

// Perform arithmetic operations
always @(*) begin
    case (aluc)
        ADD, ADDU: result = a + b;
        SUB, SUBU: result = a - b;
        default: result = 32'bz;
    endcase
end

// Generate flags
assign zero = (result == 32'h0)? 1'b1 : 1'b0;
assign carry = ((aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU))?
               ((a[31] == 1'b0 && b[31] == 1'b0 && result[31] == 1'b1) ||
                (a[31] == 1'b1 && b[31] == 1'b1 && result[31] == 1'b0)) : 
               1'b0;
assign negative = result[31];
assign overflow = ((aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU))?
                  ((a[31] == 1'b0 && b[31] == 1'b0 && result[31] == 1'b1) ||
                   (a[31] == 1'b1 && b[31] == 1'b1 && result[31] == 1'b0)) : 
                  1'b0;
assign flag = ((aluc == SLT) || (aluc == SLTU))? result[0] : 1'b0;

endmodule

module logical_module(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] result,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);

// Perform logical operations
always @(*) begin
    case (aluc)
        AND: result = a & b;
        OR: result = a | b;
        XOR: result = a ^ b;
        NOR: result = ~(a | b);
        default: result = 32'bz;
    endcase
end

// Generate flags
assign zero = (result == 32'h0)? 1'b1 : 1'b0;
assign carry = 1'b0;
assign negative = result[31];
assign overflow = 1'b0;
assign flag = ((aluc == SLT) || (aluc == SLTU))? result[0] : 1'b0;

endmodule

module shift_module(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] result,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);

// Perform shift operations
always @(*) begin
    case (aluc)
        SLL: result = a << b[4:0];
        SRL: result = a >> b[4:0];
        SRA: result = a >>> b[4:0];
        SLLV: result = a << a[4:0];
        SRLV: result = a >> a[4:0];
        SRAV: result = a >>> a[4:0];
        default: result = 32'bz;
    endcase
end

// Generate flags
assign zero = (result == 32'h0)? 1'b1 : 1'b0;
assign carry = 1'b0;
assign negative = result[31];
assign overflow = 1'b0;
assign flag = ((aluc == SLT) || (aluc == SLTU))? result[0] : 1'b0;

endmodule

module comparison_module(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] result,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);

// Perform comparison operations
always @(*) begin
    case (aluc)
        SLT: result = (signed'(a) < signed'(b))? 32'h1 : 32'h0;
        SLTU: result = (a < b)? 32'h1 : 32'h0;
        default: result = 32'bz;
    endcase
end

// Generate flags
assign zero = (result == 32'h0)? 1'b1 : 1'b0;
assign carry = 1'b0;
assign negative = result[31];
assign overflow = 1'b0;
assign flag = ((aluc == SLT) || (aluc == SLTU))? result[0] : 1'b0;

endmodule

module control_module(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    input [31:0] am_result,
    input [31:0] lm_result,
    input [31:0] sm_result,
    input [31:0] cm_result,
    input zero_am,
    input zero_lm,
    input zero_sm,
    input zero_cm,
    input carry_am,
    input carry_lm,
    input carry_sm,
    input carry_cm,
    input negative_am,
    input negative_lm,
    input negative_sm,
    input negative_cm,
    input overflow_am,
    input overflow_lm,
    input overflow_sm,
    input overflow_cm,
    input flag_am,
    input flag_lm,
    input flag_sm,
    input flag_cm,
    output [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);

// Select the result based on the aluc
always @(*) begin
    case (aluc)
        ADD, ADDU, SUB, SUBU: begin
            r = am_result;
            zero = zero_am;
            carry = carry_am;
            negative = negative_am;
            overflow = overflow_am;
            flag = flag_am;
        end
        AND, OR, XOR, NOR: begin
            r = lm_result;
            zero = zero_lm;
            carry = carry_lm;
            negative = negative_lm;
            overflow = overflow_lm;
            flag = flag_lm;
        end
        SLL, SRL, SRA, SLLV, SRLV, SRAV: begin
            r = sm_result;
            zero = zero_sm;
            carry = carry_sm;
            negative = negative_sm;
            overflow = overflow_sm;
            flag = flag_sm;
        end
        SLT, SLTU: begin
            r = cm_result;
            zero = zero_cm;
            carry = carry_cm;
            negative = negative_cm;
            overflow = overflow_cm;
            flag = flag_cm;
        end
        default: begin
            r = 32'bz;
            zero = 1'bz;
            carry = 1'bz;
            negative = 1'bz;
            overflow = 1'bz;
            flag = 1'bz;
        end
    endcase
end

endmodule