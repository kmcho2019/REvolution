module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
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

    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [4:0] shift_amount = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0]; // For SLLV/SRLV/SRAV

    always @(*) begin
        carry = 0;
        overflow = 0;
        flag = 0;
        
        case (aluc)
            ADD, ADDU: begin
                {carry, r} = a + b;
                if (aluc == ADD) begin
                    overflow = (a[31] == b[31]) && (r[31] != a[31]);
                end
            end
            SUB, SUBU: begin
                {carry, r} = a - b;
                if (aluc == SUB) begin
                    overflow = (a[31] != b[31]) && (r[31] != a[31]);
                end
            end
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            SLT:  begin
                r = {31'b0, signed_a < signed_b};
                flag = signed_a < signed_b;
            end
            SLTU: begin
                r = {31'b0, a < b};
                flag = a < b;
            end
            SLL, SLLV:  r = b << shift_amount;
            SRL, SRLV:  r = b >> shift_amount;
            SRA, SRAV:  r = $signed(b) >>> shift_amount;
            LUI:  r = {b[15:0], 16'b0};
            default: r = 32'b0;
        endcase
    end

    assign zero = (r == 32'b0);
    assign negative = r[31];

endmodule