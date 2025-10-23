module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output reg         zero,
    output reg         carry,
    output reg         negative,
    output reg         overflow,
    output reg         flag
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

    // Internal variables for arithmetic with carry
    reg [32:0] add_ext;
    reg [32:0] sub_ext;

    // Shift amount for variable shifts
    wire [4:0] shamt = a[4:0];

    // Signed inputs for arithmetic and comparisons
    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;

    always @(*) begin
        // Default assignments
        r = 32'bz;
        zero = 1'b0;
        carry = 1'b0;
        negative = 1'b0;
        overflow = 1'b0;
        flag = 1'bz; // high impedance default for flag unless set by SLT or SLTU

        // Arithmetic extended operands
        add_ext = {1'b0, a} + {1'b0, b};
        sub_ext = {1'b0, a} - {1'b0, b};

        case(aluc)
            ADD: begin
                r = add_ext[31:0];
                carry = add_ext[32];
                // Overflow detection for signed addition
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
                flag = 1'bz;
            end
            ADDU: begin
                r = add_ext[31:0];
                carry = add_ext[32];
                overflow = 1'b0;
                flag = 1'bz;
            end
            SUB: begin
                r = sub_ext[31:0];
                // Carry in subtraction indicates no borrow if 1, borrow if 0
                carry = ~sub_ext[32];
                // Overflow detection for signed subtraction
                overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
                flag = 1'bz;
            end
            SUBU: begin
                r = sub_ext[31:0];
                carry = ~sub_ext[32];
                overflow = 1'b0;
                flag = 1'bz;
            end
            AND: begin
                r = a & b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            OR: begin
                r = a | b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            XOR: begin
                r = a ^ b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            NOR: begin
                r = ~(a | b);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SLT: begin
                r = (a_s < b_s) ? 32'd1 : 32'd0;
                carry = 1'b0;
                overflow = 1'b0;
                flag = (a_s < b_s) ? 1'b1 : 1'b0;
            end
            SLTU: begin
                r = (a < b) ? 32'd1 : 32'd0;
                carry = 1'b0;
                overflow = 1'b0;
                flag = (a < b) ? 1'b1 : 1'b0;
            end
            SLL: begin
                r = b << shamt;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRL: begin
                r = b >> shamt;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRA: begin
                r = $signed(b) >>> shamt;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SLLV: begin
                r = b << shamt;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRLV: begin
                r = b >> shamt;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRAV: begin
                r = $signed(b) >>> shamt;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            LUI: begin
                r = {a[15:0], 16'b0};
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            default: begin
                r = 32'bz;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
        endcase

        // zero and negative flags updated in all cases if r is defined
        zero = (r === 32'b0) ? 1'b1 : 1'b0;
        negative = (r[31] === 1'b1) ? 1'b1 : 1'b0;
    end

endmodule