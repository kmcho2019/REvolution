module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
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

    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    reg [32:0] res_ext;  // 33-bit extended result for carry detection
    wire [31:0] res = res_ext[31:0];

    // Flag outputs
    assign zero = (res == 32'b0);
    assign carry = res_ext[32];
    assign negative = res[31];
    assign overflow = (aluc == ADD || aluc == SUB) ? 
                     ((aluc == ADD) ? ((signed_a[31] == signed_b[31]) && (res[31] != signed_a[31])) :
                                      ((signed_a[31] != signed_b[31]) && (res[31] != signed_a[31]))) : 1'b0;

    always @(*) begin
        flag = 1'bz;  // Default high impedance
        res_ext = 33'b0;

        case (aluc)
            ADD: begin
                res_ext = {signed_a[31], signed_a} + {signed_b[31], signed_b};
            end
            ADDU: begin
                res_ext = a + b;
            end
            SUB: begin
                res_ext = {signed_a[31], signed_a} - {signed_b[31], signed_b};
            end
            SUBU: begin
                res_ext = a - b;
            end
            AND: begin
                res_ext = a & b;
            end
            OR: begin
                res_ext = a | b;
            end
            XOR: begin
                res_ext = a ^ b;
            end
            NOR: begin
                res_ext = ~(a | b);
            end
            SLT: begin
                flag = (signed_a < signed_b);
                res_ext = {32'b0, flag};
            end
            SLTU: begin
                flag = (a < b);
                res_ext = {32'b0, flag};
            end
            SLL: begin
                res_ext = b << a[4:0];
            end
            SRL: begin
                res_ext = b >> a[4:0];
            end
            SRA: begin
                res_ext = $signed(b) >>> a[4:0];
            end
            SLLV: begin
                res_ext = b << a[4:0];
            end
            SRLV: begin
                res_ext = b >> a[4:0];
            end
            SRAV: begin
                res_ext = $signed(b) >>> a[4:0];
            end
            LUI: begin
                res_ext = {b[15:0], 16'b0};
            end
            default: begin
                res_ext = 33'bz;
            end
        endcase
    end

    always @(*) begin
        r = res;
    end

endmodule