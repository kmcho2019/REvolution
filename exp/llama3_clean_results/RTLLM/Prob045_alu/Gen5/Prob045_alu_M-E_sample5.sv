module hybrid_alu(
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

// Stage 1: Operand Preparation
reg [31:0] operand_a;
reg [31:0] operand_b;
always @(*) begin
    case (aluc)
        ADD, ADDU, SUB, SUBU: begin
            operand_a = a;
            operand_b = b;
        end
        AND, OR, XOR, NOR: begin
            operand_a = a;
            operand_b = b;
        end
        SLL, SRL, SRA: begin
            operand_a = a;
            operand_b = {28'd0, b[4:0]};
        end
        SLLV, SRLV, SRAV: begin
            operand_a = a;
            operand_b = {28'd0, a[4:0]};
        end
        LUI: begin
            operand_a = {16'd0, b[15:0]};
            operand_b = 32'd0;
        end
        SLT, SLTU: begin
            operand_a = a;
            operand_b = b;
        end
        default: begin
            operand_a = 32'bz;
            operand_b = 32'bz;
        end
    endcase
end

// Stage 2: Operation Execution
reg [31:0] result;
always @(*) begin
    case (aluc)
        ADD, ADDU: result = operand_a + operand_b;
        SUB, SUBU: result = operand_a - operand_b;
        AND: result = operand_a & operand_b;
        OR: result = operand_a | operand_b;
        XOR: result = operand_a ^ operand_b;
        NOR: result = ~(operand_a | operand_b);
        SLL: result = operand_a << operand_b[4:0];
        SRL: result = operand_a >> operand_b[4:0];
        SRA: result = operand_a >>> operand_b[4:0];
        SLLV: result = operand_a << operand_a[4:0];
        SRLV: result = operand_a >> operand_a[4:0];
        SRAV: result = operand_a >>> operand_a[4:0];
        LUI: result = operand_a;
        SLT: result = (signed'(operand_a) < signed'(operand_b)) ? 32'h1 : 32'h0;
        SLTU: result = (operand_a < operand_b) ? 32'h1 : 32'h0;
        default: result = 32'bz;
    endcase
end

// Stage 3: Result Processing
always @(*) begin
    zero = (result == 32'h0) ? 1'b1 : 1'b0;
    carry = ((aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU)) ?
             ((operand_a[31] == 1'b0 && operand_b[31] == 1'b0 && result[31] == 1'b1) ||
              (operand_a[31] == 1'b1 && operand_b[31] == 1'b1 && result[31] == 1'b0)) : 
             1'b0;
    negative = result[31];
    overflow = ((aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU)) ?
               ((operand_a[31] == 1'b0 && operand_b[31] == 1'b0 && result[31] == 1'b1) ||
                (operand_a[31] == 1'b1 && operand_b[31] == 1'b1 && result[31] == 1'b0)) : 
               1'b0;
    flag = ((aluc == SLT) || (aluc == SLTU)) ? result[0] : 1'b0;
end

assign r = result;

endmodule