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

    // Internal signals
    reg [32:0] res_ext;  // Extended result for carry detection
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire [4:0] shamt = b[4:0];  // Shift amount for variable shifts

    // Status flags
    assign zero = (r == 32'b0);
    assign carry = res_ext[32];
    assign negative = r[31];
    assign overflow = (aluc == ADD || aluc == SUB) ? 
                     ((aluc == ADD) ? 
                      ((a_signed[31] == b_signed[31]) && (r[31] != a_signed[31])) :
                      ((a_signed[31] != b_signed[31]) && (r[31] != a_signed[31]))) : 1'b0;

    always @(*) begin
        res_ext = 33'b0;
        flag = 1'bz;  // Default to high-impedance
        
        case (aluc)
            ADD, ADDU: begin
                res_ext = {1'b0, a} + {1'b0, b};
                r = res_ext[31:0];
            end
            SUB, SUBU: begin
                res_ext = {1'b0, a} - {1'b0, b};
                r = res_ext[31:0];
            end
            AND: r = a & b;
            OR:  r = a | b;
            XOR: r = a ^ b;
            NOR: r = ~(a | b);
            SLT: begin
                r = (a_signed < b_signed) ? 32'b1 : 32'b0;
                flag = r[0];
            end
            SLTU: begin
                r = (a < b) ? 32'b1 : 32'b0;
                flag = r[0];
            end
            SLL: r = b << a[4:0];
            SRL: r = b >> a[4:0];
            SRA: r = $signed(b) >>> a[4:0];
            SLLV: r = b << shamt;
            SRLV: r = b >> shamt;
            SRAV: r = $signed(b) >>> shamt;
            LUI: r = {b[15:0], 16'b0};
            default: r = 32'bz;  // Undefined operation
        endcase
    end

endmodule