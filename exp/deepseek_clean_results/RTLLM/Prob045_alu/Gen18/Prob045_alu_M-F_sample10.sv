module alu(
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

    // Internal signals
    wire [4:0] shamt = (aluc[3] ? a[4:0] : b[4:0]);  // Shared shift amount calculation
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire r_sign;
    reg [32:0] arith_result;
    reg need_arith_flags;

    always @(*) begin
        need_arith_flags = 1'b0;
        case (aluc)
            // Arithmetic operations
            ADD, ADDU: begin
                arith_result = {1'b0, a} + {1'b0, b};
                r = arith_result[31:0];
                need_arith_flags = 1'b1;
            end
            SUB, SUBU: begin
                arith_result = {1'b0, a} - {1'b0, b};
                r = arith_result[31:0];
                need_arith_flags = 1'b1;
            end
            
            // Logical operations
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            
            // Comparison operations
            SLT:  r = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            SLTU: r = (a < b) ? 32'd1 : 32'd0;
            
            // Shift operations
            SLL, SLLV:  r = b << shamt;
            SRL, SRLV:  r = b >> shamt;
            SRA, SRAV:  r = $signed(b) >>> shamt;
            
            // Immediate operation
            LUI:  r = {b[15:0], 16'b0};
            
            // Undefined operation
            default: r = 32'bz;
        endcase
    end

    // Flag generation
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = need_arith_flags ? arith_result[32] : 1'b0;
    assign overflow = need_arith_flags ? 
                    ((aluc == ADD) & (a_sign == b_sign) & (r[31] != a_sign)) |
                    ((aluc == SUB) & (a_sign != b_sign) & (r[31] != a_sign)) : 1'b0;
    assign flag = (aluc == SLT | aluc == SLTU) ? r[0] : 1'b0;

endmodule