module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output reg         negative,
    output reg         overflow,
    output reg         flag
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

wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);
wire [4:0] shamt = a[4:0];

reg [32:0] arith_temp; // for carry out in add/sub

always @(*) begin
    // Default outputs
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;
    negative = 1'b0;

    case (aluc)
        ADD: begin
            arith_temp = {1'b0, a} + {1'b0, b};
            r = arith_temp[31:0];
            carry = arith_temp[32];
            // signed overflow detection
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
        end
        ADDU: begin
            arith_temp = {1'b0, a} + {1'b0, b};
            r = arith_temp[31:0];
            carry = arith_temp[32];
            overflow = 1'b0;
        end
        SUB: begin
            arith_temp = {1'b0, a} - {1'b0, b};
            r = arith_temp[31:0];
            // carry set as borrow inverted: 1 if no borrow
            carry = (a >= b);
            // signed overflow detection
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
        end
        SUBU: begin
            arith_temp = {1'b0, a} - {1'b0, b};
            r = arith_temp[31:0];
            carry = (a >= b);
            overflow = 1'b0;
        end
        AND: begin
            r = a & b;
        end
        OR: begin
            r = a | b;
        end
        XOR: begin
            r = a ^ b;
        end
        NOR: begin
            r = ~(a | b);
        end
        SLT: begin
            flag = (a_s < b_s);
            r = {31'b0, flag};
        end
        SLTU: begin
            flag = (a < b);
            r = {31'b0, flag};
        end
        SLL: begin
            r = b << shamt;
        end
        SRL: begin
            r = b >> shamt;
        end
        SRA: begin
            r = b_s >>> shamt;
        end
        SLLV: begin
            r = b << a[4:0];
        end
        SRLV: begin
            r = b >> a[4:0];
        end
        SRAV: begin
            r = b_s >>> a[4:0];
        end
        LUI: begin
            // Standard MIPS LUI: shift b (immediate) left 16 bits
            r = b << 16;
        end
        default: begin
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase

    negative = r[31];
end

assign zero = (r == 32'b0);

endmodule