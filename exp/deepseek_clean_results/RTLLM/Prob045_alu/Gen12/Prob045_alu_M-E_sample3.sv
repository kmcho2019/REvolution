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

    // Operation classification
    wire is_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire is_compare = (aluc == SLT || aluc == SLTU);
    wire is_lui = (aluc == LUI);

    // Pipeline 1: Arithmetic Operations
    reg [31:0] arith_result;
    reg arith_carry, arith_overflow;
    always @(*) begin
        if (is_arith) begin
            case (aluc[1:0])
                2'b00, 2'b01: {arith_carry, arith_result} = a + b; // ADD/ADDU
                2'b10, 2'b11: {arith_carry, arith_result} = a - b; // SUB/SUBU
            endcase
            
            // Early overflow prediction
            if (aluc == ADD) begin
                arith_overflow = (~a[31] & ~b[31] & arith_result[31]) | 
                                 (a[31] & b[31] & ~arith_result[31]);
            end
            else if (aluc == SUB) begin
                arith_overflow = (~a[31] & b[31] & arith_result[31]) | 
                                 (a[31] & ~b[31] & ~arith_result[31]);
            end
            else begin
                arith_overflow = 1'b0;
            end
        end
        else begin
            arith_result = 32'b0;
            arith_carry = 1'b0;
            arith_overflow = 1'b0;
        end
    end

    // Pipeline 2: Logical Operations
    reg [31:0] logic_result;
    always @(*) begin
        if (is_logic) begin
            case (aluc[2:0])
                3'b100: logic_result = a & b;  // AND
                3'b101: logic_result = a | b;  // OR
                3'b110: logic_result = a ^ b;  // XOR
                3'b111: logic_result = ~(a | b); // NOR
                default: logic_result = 32'b0;
            endcase
        end
        else begin
            logic_result = 32'b0;
        end
    end

    // Pipeline 3: Shift Operations
    reg [31:0] shift_result;
    always @(*) begin
        if (is_shift || is_lui) begin
            case (aluc)
                SLL:  shift_result = b << a[4:0];
                SRL:  shift_result = b >> a[4:0];
                SRA:  shift_result = $signed(b) >>> a[4:0];
                SLLV: shift_result = b << a[4:0];
                SRLV: shift_result = b >> a[4:0];
                SRAV: shift_result = $signed(b) >>> a[4:0];
                LUI:  shift_result = {b[15:0], 16'b0};
                default: shift_result = 32'b0;
            endcase
        end
        else begin
            shift_result = 32'b0;
        end
    end

    // Comparison Operations
    reg compare_result;
    always @(*) begin
        if (is_compare) begin
            case (aluc)
                SLT:  compare_result = $signed(a) < $signed(b);
                SLTU: compare_result = a < b;
                default: compare_result = 1'b0;
            endcase
        end
        else begin
            compare_result = 1'b0;
        end
    end

    // Unified Result Selection
    always @(*) begin
        case (1'b1)
            is_arith:  r = arith_result;
            is_logic: r = logic_result;
            is_shift:  r = shift_result;
            is_lui:   r = shift_result;
            is_compare: r = {31'b0, compare_result};
            default:   r = 32'b0;
        endcase
    end

    // Predictive Flag Generation
    assign zero = (is_arith) ? (arith_result == 32'b0) :
                  (is_logic) ? (logic_result == 32'b0) :
                  (is_shift || is_lui) ? (shift_result == 32'b0) :
                  (is_compare) ? ~compare_result : 1'b0;

    assign carry = is_arith ? arith_carry : 1'b0;
    assign negative = r[31];
    assign overflow = is_arith ? arith_overflow : 1'b0;
    assign flag = is_compare ? compare_result : 1'b0;

endmodule