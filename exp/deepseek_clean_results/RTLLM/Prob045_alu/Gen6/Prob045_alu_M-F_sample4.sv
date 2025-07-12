module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    input enable,
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

    // Internal signals
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire [4:0] shift_amount = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0];
    wire [31:0] b_operand = (aluc == SUB || aluc == SUBU) ? ~b : b;
    wire [32:0] adder_result = {1'b0, a} + {1'b0, b_operand} + ((aluc == SUB || aluc == SUBU) ? 1 : 0);
    wire [31:0] shift_result;

    // Shift operations
    assign shift_result = 
        (aluc == SLL || aluc == SLLV) ? b << shift_amount :
        (aluc == SRL || aluc == SRLV) ? b >> shift_amount :
        (aluc == SRA || aluc == SRAV) ? $signed(b) >>> shift_amount : 32'b0;

    // Main operation selection
    always @(*) begin
        if (!enable) begin
            r = 32'bz;
            flag = 1'bz;
        end else begin
            case (aluc)
                ADD, ADDU: r = adder_result[31:0];
                SUB, SUBU: r = adder_result[31:0];
                AND:       r = a & b;
                OR:        r = a | b;
                XOR:       r = a ^ b;
                NOR:       r = ~(a | b);
                SLT:       begin r = 0; flag = a_signed < b_signed; end
                SLTU:      begin r = 0; flag = a < b; end
                LUI:       r = {b[15:0], 16'b0};
                SLL, SRL, SRA, SLLV, SRLV, SRAV: r = shift_result;
                default:   r = 32'b0;
            endcase
        end
    end

    // Flag outputs
    assign zero = (r == 32'b0);
    assign carry = enable && ((aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) && adder_result[32]);
    assign negative = enable && r[31];
    assign overflow = enable && (
        (aluc == ADD) ? (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]) :
        (aluc == SUB) ? (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]) : 1'b0
    );

endmodule