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

    // Internal signals
    wire [31:0] sum = a + b;
    wire [31:0] diff = a - b;
    wire arith_op = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);

    always @(*) begin
        case (aluc)
            // Arithmetic operations
            ADD, ADDU: r = sum;
            SUB, SUBU: r = diff;
            
            // Logical operations
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            
            // Comparison operations
            SLT:  r = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            SLTU: r = (a < b) ? 32'd1 : 32'd0;
            
            // Shift operations
            SLL:  r = b << a[4:0];
            SRL:  r = b >> a[4:0];
            SRA:  r = $signed(b) >>> a[4:0];
            SLLV: r = b << a[4:0];
            SRLV: r = b >> a[4:0];
            SRAV: r = $signed(b) >>> a[4:0];
            
            // Immediate operation
            LUI:  r = {b[15:0], 16'b0};
            
            // Default to zero
            default: r = 32'b0;
        endcase
    end

    // Flag generation
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = arith_op ? (aluc[0] ? sum[32] : diff[32]) : 1'b0;
    assign overflow = arith_op && (
                    (aluc[1] ? (a[31] != b[31]) && (r[31] != a[31])  // SUB
                             : (a[31] == b[31]) && (r[31] != a[31])); // ADD
    assign flag = (aluc == SLT || aluc == SLTU) ? r[0] : 1'b0;

endmodule