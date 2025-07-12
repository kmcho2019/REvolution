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

    // Operation type detection
    wire do_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire do_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire do_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire do_compare = (aluc == SLT || aluc == SLTU);
    wire do_lui = (aluc == LUI);

    // Shared arithmetic logic
    wire is_add = (aluc == ADD || aluc == ADDU);
    wire is_sub = (aluc == SUB || aluc == SUBU);
    wire [32:0] arith_result = is_add ? ({1'b0, a} + {1'b0, b}) : 
                                        ({1'b0, a} - {1'b0, b});
    
    // Shift operations
    wire [4:0] shift_amount = (aluc[3] ? a[4:0] : b[4:0]); // SLLV/SRLV/SRAV use a[4:0]
    reg [31:0] shift_result;
    always @(*) begin
        case (aluc[1:0])
            2'b00: shift_result = b << shift_amount; // SLL/SLLV
            2'b10: shift_result = b >> shift_amount; // SRL/SRLV
            2'b11: shift_result = $signed(b) >>> shift_amount; // SRA/SRAV
            default: shift_result = 32'b0;
        endcase
    end

    // Comparison operations (computed only when needed)
    wire slt_result = (aluc == SLT) ? ($signed(a) < $signed(b)) : 1'b0;
    wire sltu_result = (aluc == SLTU) ? (a < b) : 1'b0;

    // Result selection
    always @(*) begin
        if (do_arith) begin
            r = arith_result[31:0];
        end
        else if (do_logic) begin
            case (aluc[2:0])
                3'b100: r = a & b;  // AND
                3'b101: r = a | b;  // OR
                3'b110: r = a ^ b;  // XOR
                3'b111: r = ~(a | b); // NOR
                default: r = 32'b0;
            endcase
        end
        else if (do_shift) begin
            r = shift_result;
        end
        else if (do_compare) begin
            r = {31'b0, (aluc == SLT) ? slt_result : sltu_result};
        end
        else if (do_lui) begin
            r = {b[15:0], 16'b0};
        end
        else begin
            r = 32'b0;
        end
    end

    // Flag generation
    assign zero = (r == 32'b0);
    assign carry = do_arith ? arith_result[32] : 1'b0;
    assign negative = r[31];
    
    // Optimized overflow detection
    wire add_ovf = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
    wire sub_ovf = (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]);
    assign overflow = (aluc == ADD) ? add_ovf : 
                     (aluc == SUB) ? sub_ovf : 1'b0;
    
    assign flag = do_compare ? ((aluc == SLT) ? slt_result : sltu_result) : 1'b0;

endmodule