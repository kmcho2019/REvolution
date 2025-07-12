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

    wire [4:0] shamt = a[4:0];
    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;

    reg signed [32:0] arith_res_ext; // 33-bit for carry/borrow detection
    reg signed [31:0] arith_res;

    always @* begin
        // Default assignments
        r = 32'bz;
        zero = 0;
        carry = 0;
        negative = 0;
        overflow = 0;
        flag = 1'b0;

        case (aluc)
            ADD, ADDU: begin
                arith_res_ext = {1'b0, a} + {1'b0, b};
                arith_res = arith_res_ext[31:0];
                r = arith_res;
                carry = arith_res_ext[32];
                overflow = (aluc == ADD) &&
                           ((a[31] == b[31]) && (r[31] != a[31]));
            end
            SUB, SUBU: begin
                arith_res_ext = {1'b0, a} - {1'b0, b};
                arith_res = arith_res_ext[31:0];
                r = arith_res;
                // For borrow: carry is set if no borrow (i.e., result extended bit is 1)
                carry = ~arith_res_ext[32];
                overflow = (aluc == SUB) &&
                           ((a[31] != b[31]) && (r[31] != a[31]));
            end
            AND: r = a & b;
            OR:  r = a | b;
            XOR: r = a ^ b;
            NOR: r = ~(a | b);
            SLT: begin
                flag = (a_s < b_s) ? 1'b1 : 1'b0;
                r = {31'd0, flag};
            end
            SLTU: begin
                flag = (a < b) ? 1'b1 : 1'b0;
                r = {31'd0, flag};
            end
            SLL:  r = b << shamt;
            SRL:  r = b >> shamt;
            SRA:  r = $signed(b) >>> shamt;
            SLLV: r = b << shamt;
            SRLV: r = b >> shamt;
            SRAV: r = $signed(b) >>> shamt;
            LUI:  r = {a[15:0], 16'b0};
            default: r = 32'bz;
        endcase

        zero = (r == 32'd0);
        negative = r[31];
        // If flag not set by SLT/SLTU, keep zero to avoid high-Z
        if (aluc != SLT && aluc != SLTU)
            flag = 1'b0;
    end

endmodule