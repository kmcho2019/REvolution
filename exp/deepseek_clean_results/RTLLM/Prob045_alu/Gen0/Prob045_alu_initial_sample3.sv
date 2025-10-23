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
    assign carry = res[32];
    assign negative = r[31];
    
    // Overflow detection for signed operations
    wire add_overflow = (signed_a[31] == signed_b[31]) && (res[31] != signed_a[31]);
    wire sub_overflow = (signed_a[31] != signed_b[31]) && (res[31] != signed_a[31]);
    assign overflow = ((aluc == ADD) && add_overflow) || 
                     ((aluc == SUB) && sub_overflow);

    always @(*) begin
        res = 33'b0;
        flag = 1'bz;  // Default high-impedance
        
        case (aluc)
            ADD:  res = {signed_a[31], signed_a} + {signed_b[31], signed_b};
            ADDU: res = {1'b0, a} + {1'b0, b};
            SUB:  res = {signed_a[31], signed_a} - {signed_b[31], signed_b};
            SUBU: res = {1'b0, a} - {1'b0, b};
            AND:  res = {1'b0, a & b};
            OR:   res = {1'b0, a | b};
            XOR:  res = {1'b0, a ^ b};
            NOR:  res = {1'b0, ~(a | b)};
            
            SLT: begin
                res = {1'b0, 31'b0, signed_a < signed_b};
                flag = signed_a < signed_b;
            end
            SLTU: begin
                res = {1'b0, 31'b0, a < b};
                flag = a < b;
            end
            
            SLL:  res = {1'b0, b << b_shift};
            SRL:  res = {1'b0, b >> b_shift};
            SRA:  res = {1'b0, $signed(b) >>> b_shift};
            SLLV: res = {1'b0, b << a[4:0]};
            SRLV: res = {1'b0, b >> a[4:0]};
            SRAV: res = {1'b0, $signed(b) >>> a[4:0]};
            
            LUI:  res = {1'b0, b[15:0], 16'b0};
            
            default: res = 33'bz;
        endcase
        
        r = res[31:0];
    end

endmodule