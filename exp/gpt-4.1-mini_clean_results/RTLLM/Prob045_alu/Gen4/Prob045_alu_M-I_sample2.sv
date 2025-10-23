module alu (
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output negative,
    output reg overflow,
    output reg flag
);
    // Opcode parameters
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

    wire [4:0] shamt = a[4:0];

    // Signed versions for signed comparisons and shifts
    wire signed [31:0] a_s = $signed(a);
    wire signed [31:0] b_s = $signed(b);

    // Precompute addition and subtraction results for overflow and carry detection
    wire [31:0] add_res = a + b;
    wire [31:0] sub_res = a - b;

    // Detect carry out for unsigned add/sub by checking MSB overflow in addition and subtraction
    wire add_carry_out = (add_res < a);
    wire sub_borrow_out = (a < b);

    // Overflow detection for signed addition:
    // overflow when sign of a and b are same but sign of result differs
    wire add_overflow = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);

    // Overflow detection for signed subtraction:
    // overflow when sign of a and b differ and sign of result differs from sign of a
    wire sub_overflow = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

    // SLT and SLTU flags precomputed
    wire slt_flag = (a_s < b_s);
    wire sltu_flag = (a < b);

    always @(*) begin
        // Default assignments
        r = 32'b0;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;

        case (aluc)
            ADD: begin
                r = add_res;
                overflow = add_overflow;
                carry = 1'b0;
                flag = 1'b0;
            end
            ADDU: begin
                r = add_res;
                carry = add_carry_out;
                overflow = 1'b0;
                flag = 1'b0;
            end
            SUB: begin
                r = sub_res;
                overflow = sub_overflow;
                carry = 1'b0;
                flag = 1'b0;
            end
            SUBU: begin
                r = sub_res;
                carry = ~sub_borrow_out; // carry means no borrow here
                overflow = 1'b0;
                flag = 1'b0;
            end
            AND: begin
                r = a & b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            OR: begin
                r = a | b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            XOR: begin
                r = a ^ b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            NOR: begin
                r = ~(a | b);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            SLT: begin
                flag = slt_flag ? 1'b1 : 1'b0;
                r = flag ? 32'd1 : 32'd0;
                carry = 1'b0;
                overflow = 1'b0;
            end
            SLTU: begin
                flag = sltu_flag ? 1'b1 : 1'b0;
                r = flag ? 32'd1 : 32'd0;
                carry = 1'b0;
                overflow = 1'b0;
            end
            SLL: begin
                r = b << shamt;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            SLLV: begin
                r = b << a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            SRL: begin
                r = b >> shamt;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            SRLV: begin
                r = b >> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            SRA: begin
                r = $signed(b) >>> shamt;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            SRAV: begin
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            LUI: begin
                r = {a[31:16], 16'b0};
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            default: begin
                // Default safe outputs for undefined opcodes
                r = 32'b0;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
        endcase
    end

    assign zero = (r == 32'b0);
    assign negative = r[31];

endmodule