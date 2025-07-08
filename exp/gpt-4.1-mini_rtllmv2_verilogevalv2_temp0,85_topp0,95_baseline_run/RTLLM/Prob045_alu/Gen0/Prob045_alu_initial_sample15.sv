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

    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;

    reg [32:0] res_ext; // 33 bits to capture carry out for additions/subtractions

    always @(*) begin
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'bz;
        res_ext = 33'b0;
        case (aluc)
            ADD: begin
                res_ext = {a[31], a} + {b[31], b};
                r = res_ext[31:0];
                carry = res_ext[32];
                // Overflow detection for signed add: if sign of a == sign of b and sign of result != sign of a
                overflow = (~a_s[31] & ~b_s[31] & r[31]) | (a_s[31] & b_s[31] & ~r[31]);
            end
            ADDU: begin
                res_ext = {1'b0, a} + {1'b0, b};
                r = res_ext[31:0];
                carry = res_ext[32];
                overflow = 1'b0;
            end
            SUB: begin
                res_ext = {a[31], a} - {b[31], b};
                r = res_ext[31:0];
                carry = res_ext[32];
                // Overflow detection for signed sub: if signs differ and sign of result differs from sign of a
                overflow = (~a_s[31] & b_s[31] & r[31]) | (a_s[31] & ~b_s[31] & ~r[31]);
            end
            SUBU: begin
                res_ext = {1'b0, a} - {1'b0, b};
                r = res_ext[31:0];
                carry = res_ext[32];
                overflow = 1'b0;
            end
            AND: begin
                r = a & b;
                carry = 1'b0;
                overflow = 1'b0;
            end
            OR: begin
                r = a | b;
                carry = 1'b0;
                overflow = 1'b0;
            end
            XOR: begin
                r = a ^ b;
                carry = 1'b0;
                overflow = 1'b0;
            end
            NOR: begin
                r = ~(a | b);
                carry = 1'b0;
                overflow = 1'b0;
            end
            SLT: begin
                flag = (a_s < b_s) ? 1'b1 : 1'b0;
                r = {31'b0, flag};
                carry = 1'b0;
                overflow = 1'b0;
            end
            SLTU: begin
                flag = (a < b) ? 1'b1 : 1'b0;
                r = {31'b0, flag};
                carry = 1'b0;
                overflow = 1'b0;
            end
            SLL: begin
                r = b << a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
            end
            SRL: begin
                r = b >> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
            end
            SRA: begin
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
            end
            SLLV: begin
                r = b << a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
            end
            SRLV: begin
                r = b >> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
            end
            SRAV: begin
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
            end
            LUI: begin
                r = {b[15:0],16'b0};
                carry = 1'b0;
                overflow = 1'b0;
            end
            default: begin
                r = 32'bz;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
        endcase
    end

    assign zero = (r == 32'b0) ? 1'b1 : 1'b0;
    assign negative = r[31];

endmodule