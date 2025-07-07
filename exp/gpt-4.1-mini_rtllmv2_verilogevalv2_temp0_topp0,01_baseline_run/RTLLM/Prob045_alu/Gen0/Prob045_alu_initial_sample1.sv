module alu(
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

    // Signed versions of inputs for signed operations
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;

    reg signed [32:0] res_ext; // 33-bit for carry detection
    reg [31:0] res;

    wire [4:0] shamt = a[4:0]; // shift amount from a for variable shifts

    always @(*) begin
        carry = 0;
        overflow = 0;
        flag = 1'bz;
        res_ext = 33'b0;
        res = 32'b0;

        case(aluc)
            ADD: begin
                res_ext = {a_signed[31], a_signed} + {b_signed[31], b_signed};
                res = res_ext[31:0];
                carry = res_ext[32];
                // Overflow detection for signed addition
                overflow = (~a_signed[31] & ~b_signed[31] & res[31]) | (a_signed[31] & b_signed[31] & ~res[31]);
            end
            ADDU: begin
                res_ext = {1'b0, a} + {1'b0, b};
                res = res_ext[31:0];
                carry = res_ext[32];
                overflow = 0;
            end
            SUB: begin
                res_ext = {a_signed[31], a_signed} - {b_signed[31], b_signed};
                res = res_ext[31:0];
                carry = res_ext[32]; // borrow bit in subtraction is carry here
                // Overflow detection for signed subtraction
                overflow = (a_signed[31] & ~b_signed[31] & ~res[31]) | (~a_signed[31] & b_signed[31] & res[31]);
            end
            SUBU: begin
                res_ext = {1'b0, a} - {1'b0, b};
                res = res_ext[31:0];
                carry = res_ext[32];
                overflow = 0;
            end
            AND: begin
                res = a & b;
            end
            OR: begin
                res = a | b;
            end
            XOR: begin
                res = a ^ b;
            end
            NOR: begin
                res = ~(a | b);
            end
            SLT: begin
                // signed less than
                flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
                res = {31'b0, flag};
            end
            SLTU: begin
                // unsigned less than
                flag = (a < b) ? 1'b1 : 1'b0;
                res = {31'b0, flag};
            end
            SLL: begin
                res = b << a[4:0];
            end
            SRL: begin
                res = b >> a[4:0];
            end
            SRA: begin
                res = $signed(b) >>> a[4:0];
            end
            SLLV: begin
                res = b << shamt;
            end
            SRLV: begin
                res = b >> shamt;
            end
            SRAV: begin
                res = $signed(b) >>> shamt;
            end
            LUI: begin
                res = {b[15:0], 16'b0};
            end
            default: begin
                res = 32'bz;
                flag = 1'bz;
                carry = 1'b0;
                overflow = 1'b0;
            end
        endcase
    end

    assign r = res;
    assign zero = (res == 32'b0) ? 1'b1 : 1'b0;
    assign negative = res[31];

endmodule