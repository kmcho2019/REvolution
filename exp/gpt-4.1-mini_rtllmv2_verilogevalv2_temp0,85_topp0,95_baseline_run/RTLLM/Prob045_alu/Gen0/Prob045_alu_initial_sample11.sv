module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output reg         negative,
    output reg         overflow,
    output reg         flag
);

    // Define operation codes
    parameter ADD  = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB  = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND_ = 6'b100100; // renamed to AND_ to avoid keyword clash
    parameter OR_  = 6'b100101;
    parameter XOR_ = 6'b100110;
    parameter NOR_ = 6'b100111;
    parameter SLT  = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL  = 6'b000000;
    parameter SRL  = 6'b000010;
    parameter SRA  = 6'b000011;
    parameter SLLV = 6'b000100;
    parameter SRLV = 6'b000110;
    parameter SRAV = 6'b000111;
    parameter LUI  = 6'b001111;

    reg [32:0] add_sub_ext;  // 33 bits for carry detection
    reg signed [31:0] a_signed;
    reg signed [31:0] b_signed;
    reg signed [31:0] r_signed;
    wire [4:0] shamt;
    reg [31:0] res;

    assign zero = (r == 32'b0);

    always @(*) begin
        // Initialize defaults
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'bz; // high impedance by default
        a_signed = a;
        b_signed = b;
        r = 32'bz;
        res = 32'b0;

        case(aluc)
            ADD: begin
                // signed addition with overflow detection
                add_sub_ext = {1'b0, a} + {1'b0, b};
                res = add_sub_ext[31:0];
                carry = add_sub_ext[32];
                r_signed = a_signed + b_signed;
                // Overflow: if signs of a and b same, but sign of result differs
                overflow = ((a_signed[31] == b_signed[31]) && (r_signed[31] != a_signed[31]));
                flag = 1'bz;
            end
            ADDU: begin
                // unsigned addition, carry flag set if carry out
                add_sub_ext = {1'b0, a} + {1'b0, b};
                res = add_sub_ext[31:0];
                carry = add_sub_ext[32];
                overflow = 1'b0;
                flag = 1'bz;
            end
            SUB: begin
                // signed subtraction with overflow
                add_sub_ext = {1'b0, a} - {1'b0, b};
                res = add_sub_ext[31:0];
                carry = ~add_sub_ext[32]; // borrow detection: carry=1 if no borrow
                r_signed = a_signed - b_signed;
                overflow = ((a_signed[31] != b_signed[31]) && (r_signed[31] != a_signed[31]));
                flag = 1'bz;
            end
            SUBU: begin
                // unsigned subtraction, borrow detection
                add_sub_ext = {1'b0, a} - {1'b0, b};
                res = add_sub_ext[31:0];
                carry = ~add_sub_ext[32]; // borrow: carry=1 if no borrow, so invert
                overflow = 1'b0;
                flag = 1'bz;
            end
            AND_: begin
                res = a & b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            OR_: begin
                res = a | b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            XOR_: begin
                res = a ^ b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            NOR_: begin
                res = ~(a | b);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SLT: begin
                // signed less than
                flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
                res = flag ? 32'd1 : 32'd0;
                carry = 1'b0;
                overflow = 1'b0;
            end
            SLTU: begin
                // unsigned less than
                flag = (a < b) ? 1'b1 : 1'b0;
                res = flag ? 32'd1 : 32'd0;
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
                // arithmetic right shift
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
                res = {b[15:0], 16'b0};
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
        negative = r[31];
    end

endmodule