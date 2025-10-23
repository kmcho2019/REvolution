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

// Define operation codes
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

// Define pipeline stages
parameter [1:0] IDLE = 2'b00;
parameter [1:0] EXECUTE = 2'b01;
parameter [1:0] STORE = 2'b10;

// Define reconfigurable ALU operations
parameter [2:0] ADD_OP = 3'b000;
parameter [2:0] SUB_OP = 3'b001;
parameter [2:0] AND_OP = 3'b010;
parameter [2:0] OR_OP = 3'b011;
parameter [2:0] XOR_OP = 3'b100;
parameter [2:0] NOR_OP = 3'b101;
parameter [2:0] SLT_OP = 3'b110;
parameter [2:0] SLTU_OP = 3'b111;

// Internal signals
reg [1:0] stage;
reg [2:0] reconf_op;
reg [31:0] operand_a;
reg [31:0] operand_b;
reg [31:0] result;
reg zero_reg;
reg carry_reg;
reg negative_reg;
reg overflow_reg;
reg flag_reg;

// Operation decoder
always @(aluc) begin
    case (aluc)
        ADD: reconf_op = ADD_OP;
        ADDU: reconf_op = ADD_OP;
        SUB: reconf_op = SUB_OP;
        SUBU: reconf_op = SUB_OP;
        AND: reconf_op = AND_OP;
        OR: reconf_op = OR_OP;
        XOR: reconf_op = XOR_OP;
        NOR: reconf_op = NOR_OP;
        SLT: reconf_op = SLT_OP;
        SLTU: reconf_op = SLTU_OP;
        SLL: reconf_op = ADD_OP;
        SRL: reconf_op = SUB_OP;
        SRA: reconf_op = SUB_OP;
        SLLV: reconf_op = ADD_OP;
        SRLV: reconf_op = SUB_OP;
        SRAV: reconf_op = SUB_OP;
        LUI: reconf_op = ADD_OP;
        default: reconf_op = 3'bxxx;
    endcase
end

// Pipelined execution unit
always @(posedge clk) begin
    case (stage)
        IDLE: begin
            operand_a = a;
            operand_b = b;
            stage = EXECUTE;
        end
        EXECUTE: begin
            case (reconf_op)
                ADD_OP: result = operand_a + operand_b;
                SUB_OP: result = operand_a - operand_b;
                AND_OP: result = operand_a & operand_b;
                OR_OP: result = operand_a | operand_b;
                XOR_OP: result = operand_a ^ operand_b;
                NOR_OP: result = ~(operand_a | operand_b);
                SLT_OP: result = (operand_a < operand_b)? 32'd1 : 32'd0;
                SLTU_OP: result = (operand_a < operand_b)? 32'd1 : 32'd0;
                default: result = 32'bx;
            endcase
            stage = STORE;
        end
        STORE: begin
            r = result;
            zero_reg = (result == 32'd0)? 1'b1 : 1'b0;
            carry_reg = (result[31] == 1'b1)? 1'b1 : 1'b0;
            negative_reg = (result[31] == 1'b1)? 1'b1 : 1'b0;
            overflow_reg = ((operand_a[31] == operand_b[31]) && (operand_a[31]!= result[31]))? 1'b1 : 1'b0;
            flag_reg = (reconf_op == SLT_OP || reconf_op == SLTU_OP)? 1'b1 : 1'b0;
            stage = IDLE;
        end
        default: stage = IDLE;
    endcase
end

assign zero = zero_reg;
assign carry = carry_reg;
assign negative = negative_reg;
assign overflow = overflow_reg;
assign flag = flag_reg;

endmodule