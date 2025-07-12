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
    parameter ADD  = 6'b100000;
    parameter SUB  = 6'b100010;
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

    // Internal signals
    wire [31:0] add_res = a + b;
    wire [31:0] sub_res = a - b;
    wire [31:0] shift_res;
    wire [4:0] shift_amount = aluc[2] ? a[4:0] : b[4:0]; // For variable shifts
    
    // Optimized barrel shifter
    assign shift_res = 
        (aluc[1:0] == 2'b00) ? b << shift_amount :          // SLL/SLLV
        (aluc[1:0] == 2'b10) ? b >> shift_amount :          // SRL/SRLV
        $signed(b) >>> shift_amount;                       // SRA/SRAV

    // Main operation selection with flag generation
    always @(*) begin
        case (aluc)
            ADD: begin
                r = add_res;
                carry = (a + b) < a;  // Carry out
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
                flag = 1'b0;
            end
            SUB: begin
                r = sub_res;
                carry = a >= b;       // Borrow out
                overflow = (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]);
                flag = 1'b0;
            end
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            SLT:  begin
                r = {31'b0, $signed(a) < $signed(b)};
                flag = r[0];
            end
            SLTU: begin
                r = {31'b0, a < b};
                flag = r[0];
            end
            SLL, SRL, SRA, SLLV, SRLV, SRAV: r = shift_res;
            LUI:  r = {b[15:0], 16'b0};
            default: r = 32'b0;
        endcase
    end

    // Common flag assignments
    assign zero = (r == 0);
    assign negative = r[31];
    
    // Default assignments for operations that don't use these flags
    assign carry = (aluc == ADD || aluc == SUB) ? carry : 1'b0;
    assign overflow = (aluc == ADD || aluc == SUB) ? overflow : 1'b0;
    assign flag = (aluc == SLT || aluc == SLTU) ? flag : 1'b0;

endmodule