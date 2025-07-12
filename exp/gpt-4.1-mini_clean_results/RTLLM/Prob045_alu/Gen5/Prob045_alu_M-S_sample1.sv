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

reg [32:0] add_sub_res;
reg carry_out;
reg overflow_flag;
reg slt_flag_internal;
reg sltu_flag_internal;

wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);
wire [4:0] shamt = a[4:0];

always @(*) begin
    // Default assignments
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;
    slt_flag_internal = 1'b0;
    sltu_flag_internal = 1'b0;

    case (aluc)
        ADD: begin
            add_sub_res = {1'b0, a} + {1'b0, b};
            r = add_sub_res[31:0];
            carry_out = add_sub_res[32];
            carry = carry_out;
            // Overflow detection for signed addition
            overflow_flag = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            overflow = overflow_flag;
        end

        ADDU: begin
            add_sub_res = {1'b0, a} + {1'b0, b};
            r = add_sub_res[31:0];
            carry_out = add_sub_res[32];
            carry = carry_out;
            overflow = 1'b0;
        end

        SUB: begin
            add_sub_res = {1'b0, a} + {1'b0, ~b} + 1'b1;
            r = add_sub_res[31:0];
            carry_out = add_sub_res[32];
            carry = carry_out;
            // Overflow detection for signed subtraction
            overflow_flag = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            overflow = overflow_flag;
        end

        SUBU: begin
            add_sub_res = {1'b0, a} + {1'b0, ~b} + 1'b1;
            r = add_sub_res[31:0];
            carry_out = add_sub_res[32];
            carry = carry_out;
            overflow = 1'b0;
        end

        AND:  r = a & b;
        OR:   r = a | b;
        XOR:  r = a ^ b;
        NOR:  r = ~(a | b);

        SLT: begin
            slt_flag_internal = (a_s < b_s);
            r = {31'b0, slt_flag_internal};
            flag = slt_flag_internal;
        end

        SLTU: begin
            sltu_flag_internal = (a < b);
            r = {31'b0, sltu_flag_internal};
            flag = sltu_flag_internal;
        end

        SLL:  r = b << shamt;
        SRL:  r = b >> shamt;
        SRA:  r = $signed(b_s) >>> shamt;

        SLLV: r = b << a[4:0];
        SRLV: r = b >> a[4:0];
        SRAV: r = $signed(b_s) >>> a[4:0];

        LUI:  r = {b[15:0], 16'b0};

        default: begin
            r = 32'bz;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase

    zero = (r == 32'b0);
    negative = r[31];
end

endmodule