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

wire [4:0] shamt = a[4:0];
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

reg [32:0] add_ext;
reg [32:0] sub_ext;
reg [31:0] res;
reg c;
reg ovf;
reg flg;

always @* begin
    // Default outputs
    res = 32'b0;
    c = 1'b0;
    ovf = 1'b0;
    flg = 1'b0;

    case (aluc)
        ADD: begin
            add_ext = {1'b0, a} + {1'b0, b};
            res = add_ext[31:0];
            c = add_ext[32];
            ovf = (~a[31] & ~b[31] & res[31]) | (a[31] & b[31] & ~res[31]);
        end
        ADDU: begin
            add_ext = {1'b0, a} + {1'b0, b};
            res = add_ext[31:0];
            c = add_ext[32];
            ovf = 1'b0;
        end
        SUB: begin
            sub_ext = {1'b0, a} - {1'b0, b};
            res = sub_ext[31:0];
            c = sub_ext[32];
            ovf = (a[31] & ~b[31] & ~res[31]) | (~a[31] & b[31] & res[31]);
        end
        SUBU: begin
            sub_ext = {1'b0, a} - {1'b0, b};
            res = sub_ext[31:0];
            c = sub_ext[32];
            ovf = 1'b0;
        end
        AND: res = a & b;
        OR:  res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLT: begin
            flg = (a_s < b_s);
            res = {31'b0, flg};
        end
        SLTU: begin
            flg = (a < b);
            res = {31'b0, flg};
        end
        SLL:  res = b << shamt;
        SRL:  res = b >> shamt;
        SRA:  res = $signed(b_s) >>> shamt;
        SLLV: res = b << a[4:0];
        SRLV: res = b >> a[4:0];
        SRAV: res = $signed(b_s) >>> a[4:0];
        LUI:  res = {a[15:0], 16'b0};
        default: begin
            res = 32'b0;
            c = 1'b0;
            ovf = 1'b0;
            flg = 1'b0;
        end
    endcase

    // Outputs assignment
    r = res;
    zero = (res == 32'b0);
    negative = res[31];
    carry = c;
    overflow = ovf;
    flag = (aluc == SLT || aluc == SLTU) ? flg : 1'b0;
end

endmodule