module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);

    // Operation codes
    parameter ADD   = 6'b100000;
    parameter ADDU  = 6'b100001;
    parameter SUB   = 6'b100010;
    parameter SUBU  = 6'b100011;
    parameter AND   = 6'b100100;
    parameter OR    = 6'b100101;
    parameter XOR   = 6'b100110;
    parameter NOR   = 6'b100111;
    parameter SLT   = 6'b101010;
    parameter SLTU  = 6'b101011;
    parameter SLL   = 6'b000000;
    parameter SRL   = 6'b000010;
    parameter SRA   = 6'b000011;
    parameter SLLV  = 6'b000100;
    parameter SRLV  = 6'b000110;
    parameter SRAV  = 6'b000111;
    parameter LUI   = 6'b001111;

    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [31:0] unsigned_a = a;
    wire [31:0] unsigned_b = b;
    
    reg [32:0] res;  // Extra bit for carry detection
    reg ovf, cry, neg, z, flg;

    always @(*) begin
        cry = 0;
        ovf = 0;
        flg = 1'bz;
        
        case (aluc)
            ADD: begin
                res = signed_a + signed_b;
                ovf = (signed_a[31] == signed_b[31]) && (res[31] != signed_a[31]);
                cry = res[32];
            end
            ADDU: begin
                res = unsigned_a + unsigned_b;
                cry = res[32];
            end
            SUB: begin
                res = signed_a - signed_b;
                ovf = (signed_a[31] != signed_b[31]) && (res[31] != signed_a[31]);
                cry = res[32];
            end
            SUBU: begin
                res = unsigned_a - unsigned_b;
                cry = res[32];
            end
            AND: res = a & b;
            OR:  res = a | b;
            XOR: res = a ^ b;
            NOR: res = ~(a | b);
            SLT: begin
                res = (signed_a < signed_b) ? 1 : 0;
                flg = res[0];
            end
            SLTU: begin
                res = (unsigned_a < unsigned_b) ? 1 : 0;
                flg = res[0];
            end
            SLL: res = b << a[4:0];
            SRL: res = b >> a[4:0];
            SRA: res = $signed(b) >>> a[4:0];
            SLLV: res = b << a[4:0];
            SRLV: res = b >> a[4:0];
            SRAV: res = $signed(b) >>> a[4:0];
            LUI: res = {b[15:0], 16'b0};
            default: res = 33'bz;
        endcase
    end

    assign r = res[31:0];
    assign zero = (r == 32'b0);
    assign carry = cry;
    assign negative = r[31];
    assign overflow = ovf;
    assign flag = flg;

endmodule