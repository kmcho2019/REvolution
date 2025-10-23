module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
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

    reg [32:0] arith_result; // Extra bit for carry detection
    wire [4:0] shift_amount;

    assign shift_amount = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0]; // For SLLV/SRLV/SRAV

    always @(*) begin
        // Default outputs
        r = 32'bz;
        carry = 0;
        overflow = 0;
        flag = 0;
        negative = 0;
        zero = 0;

        case (aluc)
            ADD, ADDU, SUB, SUBU: begin
                arith_result = (aluc[1]) ? {1'b0, a} - {1'b0, b} : {1'b0, a} + {1'b0, b};
                r = arith_result[31:0];
                carry = arith_result[32];
                
                // Overflow only for signed operations
                if (aluc[0] == 0) begin
                    overflow = (a[31] == b[31]) && (r[31] != a[31]);
                end
            end
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            SLT:  begin 
                r = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
                flag = r[0];
            end
            SLTU: begin 
                r = (a < b) ? 32'd1 : 32'd0;
                flag = r[0];
            end
            SLL, SLLV:  r = b << shift_amount;
            SRL, SRLV:  r = b >> shift_amount;
            SRA, SRAV:  r = $signed(b) >>> shift_amount;
            LUI:  r = {b[15:0], 16'b0};
            default: r = 32'bz;
        endcase

        // Common flag updates
        negative = r[31];
        zero = (r == 0);
    end

endmodule