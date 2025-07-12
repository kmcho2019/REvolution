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
    reg [32:0] res;  // Extra bit for carry detection
    wire [4:0] shamt = b[4:0];  // Shift amount for variable shifts

    assign zero = (r == 32'b0);
    assign carry = res[32];
    assign negative = r[31];
    assign overflow = (aluc == ADD || aluc == SUB) ? 
                     ((aluc == ADD) ? 
                      ((signed_a[31] == signed_b[31]) && (res[31] != signed_a[31])) :
                      ((signed_a[31] != signed_b[31]) && (res[31] != signed_a[31]))) : 1'b0;

    always @(*) begin
        res = 33'b0;
        flag = 1'bz;  // Default high-impedance
        
        case (aluc)
            ADD, ADDU: begin
                res = {1'b0, a} + {1'b0, b};
                r = res[31:0];
            end
            SUB, SUBU: begin
                res = {1'b0, a} - {1'b0, b};
                r = res[31:0];
            end
            AND: begin
                r = a & b;
                res = {1'b0, r};
            end
            OR: begin
                r = a | b;
                res = {1'b0, r};
            end
            XOR: begin
                r = a ^ b;
                res = {1'b0, r};
            end
            NOR: begin
                r = ~(a | b);
                res = {1'b0, r};
            end
            SLT: begin
                flag = (signed_a < signed_b);
                r = {31'b0, flag};
                res = {1'b0, r};
            end
            SLTU: begin
                flag = (a < b);
                r = {31'b0, flag};
                res = {1'b0, r};
            end
            SLL: begin
                r = b << a[4:0];
                res = {1'b0, r};
            end
            SRL: begin
                r = b >> a[4:0];
                res = {1'b0, r};
            end
            SRA: begin
                r = $signed(b) >>> a[4:0];
                res = {1'b0, r};
            end
            SLLV: begin
                r = b << shamt;
                res = {1'b0, r};
            end
            SRLV: begin
                r = b >> shamt;
                res = {1'b0, r};
            end
            SRAV: begin
                r = $signed(b) >>> shamt;
                res = {1'b0, r};
            end
            LUI: begin
                r = {b[15:0], 16'b0};
                res = {1'b0, r};
            end
            default: begin
                r = 32'bz;
                res = 33'bz;
            end
        endcase
    end

endmodule