module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output wire        negative,
    output reg         overflow,
    output wire        flag
);

// Opcode parameters
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

wire [4:0] shamt = a[4:0];

// Intermediate variables
reg [32:0] sum_sub;   // 33-bit for carry detection
reg [31:0] alu_out;
reg slt_flag;
reg sltu_flag;

always @* begin
    carry = 1'b0;
    overflow = 1'b0;
    alu_out = 32'b0;
    slt_flag = 1'b0;
    sltu_flag = 1'b0;

    case (aluc)
        ADD: begin
            sum_sub = {1'b0,a} + {1'b0,b};
            alu_out = sum_sub[31:0];
            carry = sum_sub[32];
            // Overflow detection for signed add: 
            // when sign of a == sign of b but differs from result sign
            overflow = (~a[31] & ~b[31] & alu_out[31]) | (a[31] & b[31] & ~alu_out[31]);
        end
        ADDU: begin
            sum_sub = {1'b0,a} + {1'b0,b};
            alu_out = sum_sub[31:0];
            carry = sum_sub[32];
            overflow = 1'b0;
        end
        SUB: begin
            sum_sub = {1'b0,a} - {1'b0,b};
            alu_out = sum_sub[31:0];
            carry = sum_sub[32];
            // Overflow detection for signed subtraction:
            // when sign of a != sign of b and sign of result != sign of a
            overflow = (a[31] & ~b[31] & ~alu_out[31]) | (~a[31] & b[31] & alu_out[31]);
        end
        SUBU: begin
            sum_sub = {1'b0,a} - {1'b0,b};
            alu_out = sum_sub[31:0];
            carry = sum_sub[32];
            overflow = 1'b0;
        end
        AND: alu_out = a & b;
        OR:  alu_out = a | b;
        XOR: alu_out = a ^ b;
        NOR: alu_out = ~(a | b);
        SLT: begin
            slt_flag = ($signed(a) < $signed(b));
            alu_out = {31'b0, slt_flag};
        end
        SLTU: begin
            sltu_flag = (a < b);
            alu_out = {31'b0, sltu_flag};
        end
        SLL:  alu_out = b << shamt;
        SRL:  alu_out = b >> shamt;
        SRA:  alu_out = $signed(b) >>> shamt;
        SLLV: alu_out = b << a[4:0];
        SRLV: alu_out = b >> a[4:0];
        SRAV: alu_out = $signed(b) >>> a[4:0];
        LUI:  alu_out = {b[15:0], 16'b0}; // LUI loads immediate in upper half - corrected here per MIPS spec
        default: begin
            alu_out = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            slt_flag = 1'b0;
            sltu_flag = 1'b0;
        end
    endcase

    r = alu_out;
end

// zero flag combinational from result
assign zero = (r == 32'b0);
// negative flag combinational from result MSB
assign negative = r[31];
// flag output: driven only for SLT and SLTU, else 'z' (high-impedance)
assign flag = (aluc == SLT) ? slt_flag :
              (aluc == SLTU) ? sltu_flag :
              1'bz;

endmodule