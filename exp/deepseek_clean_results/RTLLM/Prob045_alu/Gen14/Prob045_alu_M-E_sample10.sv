module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output negative,
    output reg overflow,
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

    // Operation group detection
    wire is_arith = (aluc == ADD)  | (aluc == ADDU) | 
                   (aluc == SUB)  | (aluc == SUBU);
    wire is_logic = (aluc == AND)  | (aluc == OR) | 
                   (aluc == XOR) | (aluc == NOR);
    wire is_shift = (aluc == SLL)  | (aluc == SRL) | (aluc == SRA) | 
                   (aluc == SLLV) | (aluc == SRLV) | (aluc == SRAV);
    wire is_spec  = (aluc == SLT)  | (aluc == SLTU) | (aluc == LUI);

    // Arithmetic Unit
    wire [32:0] arith_result;
    wire arith_overflow;
    assign arith_result = (aluc[1] ? {1'b0, a} - {1'b0, b} : 
                                        {1'b0, a} + {1'b0, b});
    assign arith_overflow = (aluc[1] ? 
        (a[31] != b[31]) && (arith_result[31] != a[31]) : 
        (a[31] == b[31]) && (arith_result[31] != a[31]));

    // Logic Unit
    wire [31:0] logic_result;
    assign logic_result = 
        (aluc[1:0] == 2'b00) ? a & b :
        (aluc[1:0] == 2'b01) ? a | b :
        (aluc[1:0] == 2'b10) ? a ^ b : ~(a | b);

    // Shift Unit
    wire [4:0] shift_amount = (aluc[3] ? a[4:0] : b[4:0]);
    wire [31:0] shift_result;
    assign shift_result = 
        (aluc[2:1] == 2'b00) ? b << shift_amount :
        (aluc[2:1] == 2'b01) ? b >> shift_amount :
        $signed(b) >>> shift_amount;

    // Special Unit (SLT/SLTU/LUI)
    wire [31:0] spec_result;
    assign spec_result = 
        (aluc == SLT)  ? ($signed(a) < $signed(b)) :
        (aluc == SLTU) ? (a < b) : {b[15:0], 16'b0};

    // Early Flag Calculation
    wire result_zero = (r == 32'b0);
    wire result_neg  = r[31];
    wire slt_flag    = (aluc == SLT || aluc == SLTU) && r[0];

    // Result Selection
    always @(*) begin
        case (1'b1)
            is_arith: begin
                r = arith_result[31:0];
                carry = arith_result[32];
                overflow = arith_overflow;
                flag = 1'b0;
            end
            is_logic: begin
                r = logic_result;
                {carry, overflow, flag} = 3'b0;
            end
            is_shift: begin
                r = shift_result;
                {carry, overflow, flag} = 3'b0;
            end
            is_spec: begin
                r = spec_result;
                {carry, overflow} = 2'b0;
                flag = slt_flag;
            end
            default: begin
                r = 32'b0;
                {carry, overflow, flag} = 3'b0;
            end
        endcase
    end

    assign zero = result_zero;
    assign negative = result_neg;

endmodule