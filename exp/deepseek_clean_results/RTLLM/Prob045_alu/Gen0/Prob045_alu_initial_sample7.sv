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
    wire [31:0] b_shift = (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? b : {27'b0, a[4:0]};

    // Status flags
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = res[32];
    assign overflow = (aluc == ADD || aluc == SUB) ? 
                     ((aluc == ADD) ? ((signed_a[31] == signed_b[31]) && (res[31] != signed_a[31])) :
                                      ((signed_a[31] != signed_b[31]) && (res[31] != signed_a[31]))) : 1'b0;

    always @(*) begin
        res = 33'b0;
        flag = 1'bz;  // Default high-impedance
        
        case (aluc)
            ADD:  res = signed_a + signed_b;
            ADDU: res = a + b;
            SUB:  res = signed_a - signed_b;
            SUBU: res = a - b;
            AND:  res = a & b;
            OR:   res = a | b;
            XOR:  res = a ^ b;
            NOR:  res = ~(a | b);
            
            SLT: begin
                res = (signed_a < signed_b) ? 33'b1 : 33'b0;
                flag = res[0];
            end
            
            SLTU: begin
                res = (a < b) ? 33'b1 : 33'b0;
                flag = res[0];
            end
            
            SLL:  res = b << b_shift;
            SRL:  res = b >> b_shift;
            SRA:  res = $signed(b) >>> b_shift;
            SLLV: res = b << a[4:0];
            SRLV: res = b >> a[4:0];
            SRAV: res = $signed(b) >>> a[4:0];
            
            LUI:  res = {b[15:0], 16'b0};
            
            default: res = 33'bz;  // Undefined operation
        endcase
        
        r = res[31:0];
    end

endmodule