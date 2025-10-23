module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r = 32'bz,
    output reg zero,
    output reg carry = 0,
    output reg negative = 0,
    output reg overflow = 0,
    output reg flag = 1'bz
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

    wire [31:0] add_res = a + b;
    wire [31:0] sub_res = a - b;
    wire [4:0] shift_amt = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0]; // For SLLV/SRLV/SRAV

    always @(*) begin
        // Default outputs
        r = 32'bz;
        carry = 0;
        overflow = 0;
        flag = 1'bz;
        negative = 0;
        zero = 0;

        case (aluc)
            ADD, ADDU: begin
                r = add_res;
                carry = (add_res < a);
                overflow = (aluc == ADD) ? (a[31] == b[31] && r[31] != a[31]) : 0;
            end
            SUB, SUBU: begin
                r = sub_res;
                carry = (a < b);
                overflow = (aluc == SUB) ? (a[31] != b[31] && r[31] != a[31]) : 0;
            end
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            SLT:  begin r = $signed(a) < $signed(b); flag = r[0]; end
            SLTU: begin r = a < b; flag = r[0]; end
            SLL, SLLV:  r = b << shift_amt;
            SRL, SRLV:  r = b >> shift_amt;
            SRA, SRAV:  r = $signed(b) >>> shift_amt;
            LUI:  r = {b[15:0], 16'b0};
            default: ; // Maintain high-impedance for invalid opcodes
        endcase

        // Common flag updates
        if (aluc != 6'bz) begin
            negative = r[31];
            zero = (r == 0);
        end
    end

endmodule