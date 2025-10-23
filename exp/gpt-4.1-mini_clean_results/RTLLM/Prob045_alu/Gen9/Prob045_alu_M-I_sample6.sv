module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output reg         zero,
    output reg         carry,
    output reg         negative,
    output reg         overflow,
    output reg         flag
);

// Define opcodes
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

// Option to use high impedance on flag output when not SLT/SLTU
localparam FLAG_TRI_STATE = 0; // 0: flag=0 else, 1: flag='z' else

wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

reg [31:0] res;
reg       res_carry;
reg       res_overflow;
reg       res_flag;

wire [4:0] shamt = a[4:0];
wire [4:0] shamt_var = a[4:0]; // for variable shift ops (SLLV, SRLV, SRAV)

always @* begin
    // Default: outputs hold previous; to minimize toggling, assign only when changed
    res = 32'b0;
    res_carry = 1'b0;
    res_overflow = 1'b0;
    res_flag = 1'b0;

    case(aluc)
        ADD: begin
            {res_carry, res} = a + b;
            // Overflow: when signs of a and b same but differ from res sign
            res_overflow = (~a[31] & ~b[31] & res[31]) | (a[31] & b[31] & ~res[31]);
        end
        ADDU: begin
            {res_carry, res} = a + b;
            res_overflow = 1'b0; // overflow ignored for unsigned add
        end
        SUB: begin
            {res_carry, res} = a - b;
            // Overflow for signed subtraction: when a and b differ sign and res sign differs from a
            res_overflow = (a[31] & ~b[31] & ~res[31]) | (~a[31] & b[31] & res[31]);
            // carry here is borrow inverted: borrow = ~carry
        end
        SUBU: begin
            {res_carry, res} = a - b;
            res_overflow = 1'b0; // overflow ignored for unsigned sub
        end
        AND: res = a & b;
        OR:  res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: begin
            res_flag = (a_s < b_s) ? 1'b1 : 1'b0;
            res = {31'b0, res_flag};
        end
        SLTU: begin
            res_flag = (a < b) ? 1'b1 : 1'b0;
            res = {31'b0, res_flag};
        end
        SLL:  res = b << shamt;
        SRL:  res = b >> shamt;
        SRA:  res = $signed(b_s) >>> shamt;
        SLLV: res = b << shamt_var;
        SRLV: res = b >> shamt_var;
        SRAV: res = $signed(b_s) >>> shamt_var;
        LUI:  res = {b[15:0], 16'b0}; // Corrected: load immediate from b to upper bits
        default: begin
            res = 32'b0;
            res_flag = 1'b0;
            res_carry = 1'b0;
            res_overflow = 1'b0;
        end
    endcase

    // Assign outputs after computation
    r = res;
    zero = (res == 32'b0);
    negative = res[31];
    carry = res_carry;
    overflow = res_overflow;

    if (aluc == SLT || aluc == SLTU) begin
        flag = res_flag;
    end else begin
        if (FLAG_TRI_STATE) 
            flag = 1'bz; // high impedance per spec
        else
            flag = 1'b0; // safer for synthesis and simulation
    end
end

endmodule