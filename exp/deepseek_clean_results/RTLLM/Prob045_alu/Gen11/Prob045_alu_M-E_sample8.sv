module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
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

    // Pipeline stage 1: Operation computation
    reg [31:0] stage1_result;
    reg [32:0] arith_result;
    reg cmp_result;
    wire [4:0] shift_amount = (aluc[3] ? a[4:0] : b[4:0]); // For variable shifts

    always @(*) begin
        case (aluc)
            ADD, ADDU: arith_result = {1'b0, a} + {1'b0, b};
            SUB, SUBU: arith_result = {1'b0, a} + {1'b0, ~b} + 33'b1;
            AND:       stage1_result = a & b;
            OR:        stage1_result = a | b;
            XOR:       stage1_result = a ^ b;
            NOR:       stage1_result = ~(a | b);
            SLT, SLTU: begin
                cmp_result = (aluc[0] ? (a < b) : ($signed(a) < $signed(b)));
                stage1_result = {31'b0, cmp_result};
            end
            LUI:       stage1_result = {b[15:0], 16'b0};
            SLL, SLLV: stage1_result = b << shift_amount;
            SRL, SRLV: stage1_result = b >> shift_amount;
            SRA, SRAV: stage1_result = $signed(b) >>> shift_amount;
            default:   stage1_result = 32'b0;
        endcase

        // Select final result
        if (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) begin
            r = arith_result[31:0];
        end else begin
            r = stage1_result;
        end
    end

    // Pipeline stage 2: Flag generation
    always @(*) begin
        flag = (aluc == SLT || aluc == SLTU) ? cmp_result : 1'b0;
    end

    assign zero = (r == 32'b0);
    assign carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) ? 
                  arith_result[32] : 1'b0;
    assign negative = r[31];
    assign overflow = (aluc == ADD || aluc == SUB) ? 
                     (arith_result[32] ^ arith_result[31]) : 1'b0;

endmodule