module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output wire        negative,
    output reg         overflow,
    output reg         flag
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

    reg [32:0] add_sub_res; // 33 bits to capture carry out for add/sub
    reg [31:0] shift_res;
    reg [31:0] res_tmp;

    always @(*) begin
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'bz;
        res_tmp = 32'bz;

        case (aluc)
            ADD: begin
                add_sub_res = {1'b0, a} + {1'b0, b};
                res_tmp = add_sub_res[31:0];
                carry = add_sub_res[32];
                // Overflow detection for signed addition
                overflow = (~a[31] & ~b[31] & res_tmp[31]) | (a[31] & b[31] & ~res_tmp[31]);
            end
            ADDU: begin
                add_sub_res = {1'b0, a} + {1'b0, b};
                res_tmp = add_sub_res[31:0];
                carry = add_sub_res[32];
                overflow = 1'b0;
            end
            SUB: begin
                add_sub_res = {1'b0, a} - {1'b0, b};
                res_tmp = add_sub_res[31:0];
                carry = ~add_sub_res[32]; // borrow flag inverted for carry
                // Overflow detection for signed subtraction
                overflow = (a[31] & ~b[31] & ~res_tmp[31]) | (~a[31] & b[31] & res_tmp[31]);
            end
            SUBU: begin
                add_sub_res = {1'b0, a} - {1'b0, b};
                res_tmp = add_sub_res[31:0];
                carry = ~add_sub_res[32];
                overflow = 1'b0;
            end
            AND: begin
                res_tmp = a & b;
            end
            OR: begin
                res_tmp = a | b;
            end
            XOR: begin
                res_tmp = a ^ b;
            end
            NOR: begin
                res_tmp = ~(a | b);
            end
            SLT: begin
                // signed comparison
                flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
                res_tmp = {31'b0, flag};
            end
            SLTU: begin
                // unsigned comparison
                flag = (a < b) ? 1'b1 : 1'b0;
                res_tmp = {31'b0, flag};
            end
            SLL: begin
                shift_res = b << a[4:0];
                res_tmp = shift_res;
            end
            SRL: begin
                shift_res = b >> a[4:0];
                res_tmp = shift_res;
            end
            SRA: begin
                shift_res = $signed(b) >>> a[4:0];
                res_tmp = shift_res;
            end
            SLLV: begin
                shift_res = b << (a[4:0]);
                res_tmp = shift_res;
            end
            SRLV: begin
                shift_res = b >> (a[4:0]);
                res_tmp = shift_res;
            end
            SRAV: begin
                shift_res = $signed(b) >>> (a[4:0]);
                res_tmp = shift_res;
            end
            LUI: begin
                res_tmp = {b[15:0], 16'b0};
            end
            default: begin
                res_tmp = 32'bz;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
        endcase

        r = res_tmp;
    end

    assign zero = (r == 32'b0) ? 1'b1 : 1'b0;
    assign negative = r[31];

endmodule