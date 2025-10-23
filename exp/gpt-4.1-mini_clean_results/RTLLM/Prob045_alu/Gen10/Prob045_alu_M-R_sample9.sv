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

reg [32:0] add_ext;
reg [32:0] sub_ext;
reg        slt_flag_tmp;
reg        sltu_flag_tmp;
reg [31:0] shift_res;
reg        carry_tmp;
reg        overflow_tmp;
reg        flag_tmp;

wire [4:0] shamt_imm = a[4:0];
wire [4:0] shamt_var = a[4:0];

always @(*) begin
    // Default assignments
    r = 32'bz;
    zero = 1'b0;
    carry = 1'b0;
    negative = 1'b0;
    overflow = 1'b0;
    flag = 1'bz;
    add_ext = 33'b0;
    sub_ext = 33'b0;
    slt_flag_tmp = 1'b0;
    sltu_flag_tmp = 1'b0;
    shift_res = 32'b0;
    carry_tmp = 1'b0;
    overflow_tmp = 1'b0;
    flag_tmp = 1'b0;

    case (aluc)
        ADD: begin
            add_ext = {1'b0, a} + {1'b0, b};
            r = add_ext[31:0];
            carry_tmp = add_ext[32];
            // Overflow detection for signed addition
            overflow_tmp = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            flag_tmp = 1'b0;
        end
        ADDU: begin
            add_ext = {1'b0, a} + {1'b0, b};
            r = add_ext[31:0];
            carry_tmp = add_ext[32];
            overflow_tmp = 1'b0; // no overflow for unsigned add
            flag_tmp = 1'b0;
        end
        SUB: begin
            sub_ext = {1'b0, a} - {1'b0, b};
            r = sub_ext[31:0];
            carry_tmp = sub_ext[32]; // borrow bit in subtraction
            // Overflow detection for signed subtraction
            overflow_tmp = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            flag_tmp = 1'b0;
        end
        SUBU: begin
            sub_ext = {1'b0, a} - {1'b0, b};
            r = sub_ext[31:0];
            carry_tmp = sub_ext[32]; // borrow bit
            overflow_tmp = 1'b0;
            flag_tmp = 1'b0;
        end
        AND: begin
            r = a & b;
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
            flag_tmp = 1'b0;
        end
        OR: begin
            r = a | b;
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
            flag_tmp = 1'b0;
        end
        XOR: begin
            r = a ^ b;
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
            flag_tmp = 1'b0;
        end
        NOR: begin
            r = ~(a | b);
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
            flag_tmp = 1'b0;
        end
        SLT: begin
            slt_flag_tmp = (a_s < b_s);
            r = {31'b0, slt_flag_tmp};
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
            flag_tmp = slt_flag_tmp;
        end
        SLTU: begin
            sltu_flag_tmp = (a < b);
            r = {31'b0, sltu_flag_tmp};
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
            flag_tmp = sltu_flag_tmp;
        end
        SLL: begin
            shift_res = b << shamt_imm;
            r = shift_res;
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
            flag_tmp = 1'b0;
        end
        SRL: begin
            shift_res = b >> shamt_imm;
            r = shift_res;
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
            flag_tmp = 1'b0;
        end
        SRA: begin
            shift_res = $signed(b_s) >>> shamt_imm;
            r = shift_res;
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
            flag_tmp = 1'b0;
        end
        SLLV: begin
            shift_res = b << shamt_var;
            r = shift_res;
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
            flag_tmp = 1'b0;
        end
        SRLV: begin
            shift_res = b >> shamt_var;
            r = shift_res;
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
            flag_tmp = 1'b0;
        end
        SRAV: begin
            shift_res = $signed(b_s) >>> shamt_var;
            r = shift_res;
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
            flag_tmp = 1'b0;
        end
        LUI: begin
            r = {a[15:0], 16'b0};
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
            flag_tmp = 1'b0;
        end
        default: begin
            r = 32'bz;
            carry_tmp = 1'b0;
            overflow_tmp = 1'b0;
            flag_tmp = 1'bz;
        end
    endcase

    zero = (r === 32'b0) ? 1'b1 : 1'b0;
    negative = r[31];
    carry = carry_tmp;
    overflow = overflow_tmp;
    flag = flag_tmp;
end

endmodule