module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r = 0,
    output reg zero,
    output reg carry = 0,
    output reg negative = 0,
    output reg overflow = 0,
    output reg flag = 0
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

    // Shared arithmetic unit
    wire [32:0] arith_res;
    wire do_sub = (aluc == SUB || aluc == SUBU);
    wire is_signed = (aluc == ADD || aluc == SUB);
    assign arith_res = do_sub ? {1'b0, a} - {1'b0, b} : {1'b0, a} + {1'b0, b};

    // Barrel shifter
    wire [4:0] shift_amt = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0]; // For SLLV/SRLV/SRAV
    wire [31:0] shift_res;
    assign shift_res = (aluc[1:0] == 2'b00) ? (b << shift_amt) :  // SLL/SLLV
                      (aluc[1:0] == 2'b10) ? (b >> shift_amt) :    // SRL/SRLV
                      ($signed(b) >>> shift_amt);                  // SRA/SRAV

    always @(*) begin
        // Default outputs
        r = 0;
        carry = 0;
        overflow = 0;
        flag = 0;
        negative = 0;
        zero = 0;

        case (aluc)
            ADD, ADDU, SUB, SUBU: begin
                r = arith_res[31:0];
                carry = arith_res[32];
                if (is_signed) begin
                    overflow = (a[31] == b[31] ^ do_sub) && (r[31] != a[31]);
                end
            end
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            SLT:  begin r = 0; flag = $signed(a) < $signed(b); end
            SLTU: begin r = 0; flag = a < b; end
            SLL, SLLV, SRL, SRLV, SRA, SRAV: r = shift_res;
            LUI:  r = {b[15:0], 16'b0};
            default: r = 0;
        endcase

        // Common flag updates (only for valid operations)
        if (aluc != 6'bz) begin
            negative = r[31];
            zero = (r == 0);
        end
    end

endmodule