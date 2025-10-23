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

wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Internal signals for arithmetic results and carry/overflow
reg [32:0] add_result_ext;
reg [32:0] sub_result_ext;

reg slt_flag;
reg sltu_flag;

reg [31:0] shift_result;

reg carry_int;
reg overflow_int;

reg flag_int;

always @(*) begin
    // Default assignments
    r = 32'b0;
    carry_int = 1'b0;
    overflow_int = 1'b0;
    slt_flag = 1'b0;
    sltu_flag = 1'b0;
    flag_int = 1'b0;
    shift_result = 32'b0;

    case (aluc)
        ADD: begin
            add_result_ext = {1'b0, a} + {1'b0, b};
            r = add_result_ext[31:0];
            carry_int = add_result_ext[32];
            // overflow for signed add: if signs of operands same and sign of result differs
            overflow_int = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            flag_int = 1'b0;
        end

        ADDU: begin
            add_result_ext = {1'b0, a} + {1'b0, b};
            r = add_result_ext[31:0];
            carry_int = add_result_ext[32];
            overflow_int = 1'b0; // unsigned add has no overflow
            flag_int = 1'b0;
        end

        SUB: begin
            sub_result_ext = {1'b0, a} - {1'b0, b};
            r = sub_result_ext[31:0];
            carry_int = sub_result_ext[32];
            // overflow for signed sub: if signs of operands differ and sign of result differs from sign of a
            overflow_int = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            flag_int = 1'b0;
        end

        SUBU: begin
            sub_result_ext = {1'b0, a} - {1'b0, b};
            r = sub_result_ext[31:0];
            carry_int = sub_result_ext[32];
            overflow_int = 1'b0; // unsigned sub no overflow
            flag_int = 1'b0;
        end

        AND: begin
            r = a & b;
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end

        OR: begin
            r = a | b;
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end

        XOR: begin
            r = a ^ b;
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end

        NOR: begin
            r = ~(a | b);
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end

        SLT: begin
            slt_flag = (a_s < b_s);
            r = 32'b0;
            r[0] = slt_flag;
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = slt_flag;
        end

        SLTU: begin
            sltu_flag = (a < b);
            r = 32'b0;
            r[0] = sltu_flag;
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = sltu_flag;
        end

        SLL: begin
            // shift amount from a[4:0]
            shift_result = b << a[4:0];
            r = shift_result;
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end

        SRL: begin
            shift_result = b >> a[4:0];
            r = shift_result;
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end

        SRA: begin
            r = $signed(b_s) >>> a[4:0];
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end

        SLLV: begin
            shift_result = b << a[4:0];
            r = shift_result;
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end

        SRLV: begin
            shift_result = b >> a[4:0];
            r = shift_result;
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end

        SRAV: begin
            r = $signed(b_s) >>> a[4:0];
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end

        LUI: begin
            r = {a[15:0], 16'b0};
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end

        default: begin
            r = 32'b0;
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end
    endcase

    zero = (r == 32'b0);
    negative = r[31];
    carry = carry_int;
    overflow = overflow_int;
    flag = flag_int;
end

endmodule