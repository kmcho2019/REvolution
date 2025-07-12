module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output reg         zero,
    output reg         carry,
    output reg         negative,
    output reg         overflow,
    output wire        flag
);

// Define opcodes as parameters
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

// Temporary variables for arithmetic with carry/overflow detection
reg [32:0] add_res;
reg [32:0] sub_res;

wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

reg slt_flag_reg;
reg sltu_flag_reg;

always @(*) begin
    // Defaults
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    slt_flag_reg = 1'b0;
    sltu_flag_reg = 1'b0;

    case (aluc)
        ADD: begin
            add_res = {1'b0, a} + {1'b0, b};
            r = add_res[31:0];
            carry = add_res[32];
            // Overflow detection for signed addition:
            // overflow when signs of a and b same, but sign of result differs
            overflow = ((a[31] == b[31]) && (r[31] != a[31]));
        end

        ADDU: begin
            add_res = {1'b0, a} + {1'b0, b};
            r = add_res[31:0];
            carry = add_res[32];
            overflow = 1'b0;
        end

        SUB: begin
            sub_res = {1'b0, a} - {1'b0, b};
            r = sub_res[31:0];
            // Borrow flag inverted is carry here
            carry = (a >= b);
            // Overflow detection for signed subtraction:
            // overflow when signs of a and b differ and sign of result differs from sign of a
            overflow = ((a[31] != b[31]) && (r[31] != a[31]));
        end

        SUBU: begin
            sub_res = {1'b0, a} - {1'b0, b};
            r = sub_res[31:0];
            carry = (a >= b);
            overflow = 1'b0;
        end

        AND: r = a & b;
        OR:  r = a | b;
        XOR: r = a ^ b;
        NOR: r = ~(a | b);

        SLT: begin
            slt_flag_reg = (a_s < b_s);
            r = 32'b0;
            r[0] = slt_flag_reg;
        end

        SLTU: begin
            sltu_flag_reg = (a < b);
            r = 32'b0;
            r[0] = sltu_flag_reg;
        end

        SLL: r = b << a[4:0];
        SRL: r = b >> a[4:0];
        SRA: r = $signed(b_s) >>> a[4:0];

        SLLV: r = b << a[4:0];
        SRLV: r = b >> a[4:0];
        SRAV: r = $signed(b_s) >>> a[4:0];

        LUI: r = {a[15:0], 16'b0};

        default: r = 32'bz; // High impedance if undefined opcode
    endcase

    // zero flag
    zero = (r == 32'b0);

    // negative flag is MSB of result (sign bit)
    negative = r[31];
end

// flag output: 1 for SLT or SLTU, 'z' (high impedance) otherwise
assign flag = (aluc == SLT) ? slt_flag_reg :
              (aluc == SLTU) ? sltu_flag_reg :
              1'bz;

endmodule