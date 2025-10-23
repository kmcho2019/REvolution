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

    // Operation group enables
    wire arith_op = (aluc[5:3] == 3'b100);
    wire bitwise_op = (aluc[5:3] == 3'b100) && (aluc[2:0] >= 3'b100);
    wire shift_op = (aluc[5:3] == 3'b000);
    wire slt_op = (aluc == SLT) || (aluc == SLTU);
    wire lui_op = (aluc == LUI);

    // Internal signals
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [4:0] shift_amount = shift_op ? (aluc[2] ? a[4:0] : b[4:0]) : 5'b0;
    
    // Arithmetic units
    wire [31:0] add_result, sub_result;
    wire add_carry, sub_carry;
    wire add_ovf, sub_ovf;
    
    // Signed arithmetic
    assign {add_carry, add_result} = signed_a + signed_b;
    assign {sub_carry, sub_result} = signed_a - signed_b;
    assign add_ovf = (signed_a[31] == signed_b[31]) && (add_result[31] != signed_a[31]);
    assign sub_ovf = (signed_a[31] != signed_b[31]) && (sub_result[31] != signed_a[31]);
    
    // Unsigned arithmetic
    wire [31:0] addu_result, subu_result;
    wire addu_carry, subu_carry;
    assign {addu_carry, addu_result} = a + b;
    assign {subu_carry, subu_result} = a - b;

    // Shared logic for bitwise operations
    wire [31:0] or_result = a | b;
    wire [31:0] and_result = a & b;
    wire [31:0] xor_result = a ^ b;
    wire [31:0] nor_result = ~or_result;

    // Barrel shifter (optimized implementation)
    wire [31:0] shift_result;
    assign shift_result = (aluc[1:0] == 2'b00) ? b << shift_amount :
                         (aluc[1:0] == 2'b10) ? b >> shift_amount :
                         $signed(b) >>> shift_amount;

    always @(*) begin
        // Default values
        carry = 0;
        overflow = 0;
        flag = 0;
        r = 32'b0;

        case (aluc)
            ADD: begin
                r = add_result;
                carry = add_carry;
                overflow = add_ovf;
            end
            ADDU: begin
                r = addu_result;
                carry = addu_carry;
            end
            SUB: begin
                r = sub_result;
                carry = sub_carry;
                overflow = sub_ovf;
            end
            SUBU: begin
                r = subu_result;
                carry = subu_carry;
            end
            AND:  r = and_result;
            OR:   r = or_result;
            XOR:  r = xor_result;
            NOR:  r = nor_result;
            SLT:  begin
                r = {31'b0, signed_a < signed_b};
                flag = r[0];
            end
            SLTU: begin
                r = {31'b0, a < b};
                flag = r[0];
            end
            SLL, SLLV, SRL, SRLV, SRA, SRAV: r = shift_result;
            LUI:  r = {b[15:0], 16'b0};
            default: r = 32'b0;
        endcase
    end

    // Output flags (optimized implementation)
    assign zero = (r == 32'b0);
    assign negative = r[31];

endmodule