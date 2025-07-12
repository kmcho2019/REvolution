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

    // Common signals
    wire [4:0] shift_amount = (aluc[3]) ? a[4:0] : b[4:0];  // For shift operations
    wire [32:0] add_sub_result;
    assign add_sub_result = (aluc[1]) ? ({1'b0, a} - {1'b0, b}) : ({1'b0, a} + {1'b0, b});

    always @(*) begin
        case (aluc)
            // Arithmetic operations
            ADD, ADDU: begin
                r = add_sub_result[31:0];
                flag = 1'b0;
            end
            SUB, SUBU: begin
                r = add_sub_result[31:0];
                flag = 1'b0;
            end
            
            // Logical operations
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            
            // Comparison operations
            SLT:  begin
                r = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
                flag = r[0];
            end
            SLTU: begin
                r = (a < b) ? 32'b1 : 32'b0;
                flag = r[0];
            end
            
            // Shift operations
            SLL, SLLV:  r = b << shift_amount;
            SRL, SRLV:  r = b >> shift_amount;
            SRA, SRAV:  r = $signed(b) >>> shift_amount;
            
            // Immediate operations
            LUI:  r = {b[15:0], 16'b0};
            
            // Default case (undefined operation)
            default: begin
                r = 32'bz;
                flag = 1'bz;
            end
        endcase
    end

    // Flag generation
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = add_sub_result[32] & ((aluc == ADD) | (aluc == ADDU) | (aluc == SUB) | (aluc == SUBU));
    
    // Overflow detection (only for signed operations)
    wire add_overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
    wire sub_overflow = (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]);
    assign overflow = (aluc == ADD) ? add_overflow : 
                    (aluc == SUB) ? sub_overflow : 1'b0;

endmodule