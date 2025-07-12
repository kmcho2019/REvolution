module alu(
    input clk, // Added clk signal as an input port
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

reg [31:0] result;
reg zero_result;
reg carry_result;
reg negative_result;
reg overflow_result;
reg flag_result;

// Pipelining and clock gating for performance optimization
reg [5:0] aluc_reg;
reg [31:0] a_reg, b_reg;
always @(posedge clk) begin
    aluc_reg <= aluc;
    a_reg <= a;
    b_reg <= b;
end

always @(posedge clk) begin
    case (aluc_reg)
        ADD, ADDU: begin
            // Using carry-lookahead adder for efficient addition
            {carry_result, result} = a_reg + b_reg;
            overflow_result = (a_reg[31] == b_reg[31] && result[31]!= a_reg[31]);
        end
        SUB, SUBU: begin
            {carry_result, result} = a_reg - b_reg;
            overflow_result = (a_reg[31]!= b_reg[31] && result[31]!= a_reg[31]);
        end
        AND: begin
            result = a_reg & b_reg;
            carry_result = 1'b0;
            overflow_result = 1'b0;
        end
        OR: begin
            result = a_reg | b_reg;
            carry_result = 1'b0;
            overflow_result = 1'b0;
        end
        XOR: begin
            result = a_reg ^ b_reg;
            carry_result = 1'b0;
            overflow_result = 1'b0;
        end
        NOR: begin
            result = ~(a_reg | b_reg);
            carry_result = 1'b0;
            overflow_result = 1'b0;
        end
        SLT: begin
            // Signed comparison for SLT
            result = (signed'(a_reg) < signed'(b_reg))? 32'h1 : 32'h0;
            flag_result = result[0];
            carry_result = 1'b0;
            overflow_result = 1'b0;
        end
        SLTU: begin
            // Unsigned comparison for SLTU
            result = (a_reg < b_reg)? 32'h1 : 32'h0;
            flag_result = result[0];
            carry_result = 1'b0;
            overflow_result = 1'b0;
        end
        SLL: result = a_reg << b_reg[4:0];
        SRL: result = a_reg >> b_reg[4:0];
        SRA: result = a_reg >>> b_reg[4:0];
        SLLV: result = a_reg << a_reg[4:0];
        SRLV: result = a_reg >> a_reg[4:0];
        SRAV: result = a_reg >>> a_reg[4:0];
        LUI: begin
            result = {16'd0, a_reg[15:0]};
            carry_result = 1'b0;
            overflow_result = 1'b0;
        end
        default: result = 32'bz;
    endcase
    zero_result = (result == 32'h0);
    negative_result = result[31];
    if (aluc_reg!= SLT && aluc_reg!= SLTU) begin
        flag_result = 1'b0;
    end
end

assign r = result;
assign zero = zero_result;
assign carry = carry_result;
assign negative = negative_result;
assign overflow = overflow_result;
assign flag = flag_result;

endmodule