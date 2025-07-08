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

    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;

    reg [32:0] tmp;  // 33-bit temp for carry detection
    reg signed [32:0] tmp_signed;
    reg [31:0] res;

    always @(*) begin
        // Defaults
        res = 32'bz;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'bz;

        case (aluc)
            ADD: begin
                tmp_signed = {a_signed[31], a_signed} + {b_signed[31], b_signed};
                res = tmp_signed[31:0];
                carry = tmp_signed[32];
                // Overflow detection for signed add: if signs of a and b same but sign of res differs
                overflow = (~(a_signed[31] ^ b_signed[31])) & (a_signed[31] ^ res[31]);
                flag = 1'bz;
            end

            ADDU: begin
                tmp = {1'b0, a} + {1'b0, b};
                res = tmp[31:0];
                carry = tmp[32];
                overflow = 1'b0;
                flag = 1'bz;
            end

            SUB: begin
                tmp_signed = {a_signed[31], a_signed} - {b_signed[31], b_signed};
                res = tmp_signed[31:0];
                carry = (a >= b) ? 1'b1 : 1'b0;  // carry as borrow flag inverted (commonly carry=1 means no borrow)
                // Overflow detection for signed sub: if signs of a and b differ and sign of res differs from a
                overflow = ((a_signed[31] ^ b_signed[31]) & (a_signed[31] ^ res[31]));
                flag = 1'bz;
            end

            SUBU: begin
                tmp = {1'b0, a} - {1'b0, b};
                res = tmp[31:0];
                carry = (a >= b) ? 1'b1 : 1'b0; // carry used same as SUB
                overflow = 1'b0;
                flag = 1'bz;
            end

            AND: begin
                res = a & b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            OR: begin
                res = a | b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            XOR: begin
                res = a ^ b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            NOR: begin
                res = ~(a | b);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SLT: begin
                // Set on less than signed
                flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
                res = {31'b0, flag};
                carry = 1'b0;
                overflow = 1'b0;
            end

            SLTU: begin
                // Set on less than unsigned
                flag = (a < b) ? 1'b1 : 1'b0;
                res = {31'b0, flag};
                carry = 1'b0;
                overflow = 1'b0;
            end

            SLL: begin
                res = b << a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SRL: begin
                res = b >> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SRA: begin
                res = $signed(b) >>> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SLLV: begin
                res = b << (a[4:0]);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SRLV: begin
                res = b >> (a[4:0]);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            SRAV: begin
                res = $signed(b) >>> (a[4:0]);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            LUI: begin
                res = {b[15:0],16'b0};
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end

            default: begin
                res = 32'bz;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
        endcase

        r = res;
    end

    assign zero = (r == 32'b0);
    assign negative = r[31];

endmodule