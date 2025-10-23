module alu(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [5:0] aluc,
    output wire [31:0] r,
    output wire zero,
    output wire carry,
    output wire negative,
    output wire overflow,
    output wire flag
);

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

// LUTs for simple operations
reg [31:0] lut_and;
reg [31:0] lut_or;
reg [31:0] lut_xor;
reg [31:0] lut_nor;

always @(*) begin
    lut_and = a & b;
    lut_or = a | b;
    lut_xor = a ^ b;
    lut_nor = ~(a | b);
end

// Arithmetic and logical blocks
reg [31:0] add_result;
reg [31:0] sub_result;
reg [31:0] shift_result;

always @(*) begin
    add_result = a + b;
    sub_result = a - b;
    shift_result = (aluc == SLL) ? (a << b[4:0]) :
                  (aluc == SRL) ? (a >> b[4:0]) :
                  (aluc == SRA) ? (a >>> b[4:0]) : 32'd0;
end

// Pipelining
reg [31:0] stage1_result;
reg [31:0] stage2_result;

always @(*) begin
    stage1_result = (aluc == AND) ? lut_and :
                   (aluc == OR) ? lut_or :
                   (aluc == XOR) ? lut_xor :
                   (aluc == NOR) ? lut_nor : 32'd0;
    stage2_result = (aluc == ADD) ? add_result :
                   (aluc == SUB) ? sub_result :
                   (aluc == SLL || aluc == SRL || aluc == SRA) ? shift_result : 32'd0;
end

// Control signals
reg [31:0] r_reg;
reg zero_reg;
reg carry_reg;
reg negative_reg;
reg overflow_reg;
reg flag_reg;

always @(*) begin
    case (aluc)
        ADD: begin
            r_reg = add_result;
            zero_reg = (add_result == 0);
            carry_reg = (a[31] == b[31] && a[31] != add_result[31]);
            negative_reg = add_result[31];
            overflow_reg = (a[31] == b[31] && a[31] != add_result[31]);
            flag_reg = 0;
        end
        SUB: begin
            r_reg = sub_result;
            zero_reg = (sub_result == 0);
            carry_reg = (a[31] != b[31] && a[31] == sub_result[31]);
            negative_reg = sub_result[31];
            overflow_reg = (a[31] != b[31] && a[31] == sub_result[31]);
            flag_reg = 0;
        end
        AND: begin
            r_reg = lut_and;
            zero_reg = (lut_and == 0);
            carry_reg = 0;
            negative_reg = lut_and[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        OR: begin
            r_reg = lut_or;
            zero_reg = (lut_or == 0);
            carry_reg = 0;
            negative_reg = lut_or[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        XOR: begin
            r_reg = lut_xor;
            zero_reg = (lut_xor == 0);
            carry_reg = 0;
            negative_reg = lut_xor[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        NOR: begin
            r_reg = lut_nor;
            zero_reg = (lut_nor == 0);
            carry_reg = 0;
            negative_reg = lut_nor[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        SLT: begin
            r_reg = (a < b) ? 1 : 0;
            zero_reg = (r_reg == 0);
            carry_reg = 0;
            negative_reg = r_reg;
            overflow_reg = 0;
            flag_reg = (a < b);
        end
        SLTU: begin
            r_reg = (a < b) ? 1 : 0;
            zero_reg = (r_reg == 0);
            carry_reg = 0;
            negative_reg = r_reg;
            overflow_reg = 0;
            flag_reg = (a < b);
        end
        SLL: begin
            r_reg = a << b[4:0];
            zero_reg = (r_reg == 0);
            carry_reg = 0;
            negative_reg = r_reg[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        SRL: begin
            r_reg = a >> b[4:0];
            zero_reg = (r_reg == 0);
            carry_reg = 0;
            negative_reg = r_reg[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        SRA: begin
            r_reg = a >>> b[4:0];
            zero_reg = (r_reg == 0);
            carry_reg = 0;
            negative_reg = r_reg[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        LUI: begin
            r_reg = {a[15:0], 16'd0};
            zero_reg = (r_reg == 0);
            carry_reg = 0;
            negative_reg = r_reg[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        default: begin
            r_reg = 32'd0;
            zero_reg = 1;
            carry_reg = 0;
            negative_reg = 0;
            overflow_reg = 0;
            flag_reg = 0;
        end
    endcase
end

assign r = r_reg;
assign zero = zero_reg;
assign carry = carry_reg;
assign negative = negative_reg;
assign overflow = overflow_reg;
assign flag = flag_reg;

endmodule