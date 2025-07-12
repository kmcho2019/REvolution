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
wire [4:0] shamt = a[4:0];

reg [31:0] res;
reg c;
reg o;
reg f;

// Intermediate addition/subtraction with carry out
wire [32:0] add_res  = {1'b0, a} + {1'b0, b};
wire [32:0] addu_res = {1'b0, a} + {1'b0, b};
wire [32:0] sub_res  = {1'b0, a} - {1'b0, b};
wire [32:0] subu_res = {1'b0, a} - {1'b0, b};

always @(*) begin
    // Default outputs
    res      = 32'b0;
    c        = 1'b0;
    o        = 1'b0;
    f        = 1'b0;

    case (aluc)
        ADD: begin
            {c, res} = a + b; // full 33-bit addition
            // Overflow detection: if signs of a,b same but result sign differs
            o = (~a[31] & ~b[31] & res[31]) | (a[31] & b[31] & ~res[31]);
        end
        ADDU: begin
            {c, res} = a + b;
            o = 1'b0; // no overflow in unsigned add
        end
        SUB: begin
            {c, res} = a - b;
            // Overflow detection for signed subtraction
            o = (a[31] & ~b[31] & ~res[31]) | (~a[31] & b[31] & res[31]);
        end
        SUBU: begin
            {c, res} = a - b;
            o = 1'b0; // no overflow in unsigned sub
        end
        AND:  res = a & b;
        OR:   res = a | b;
        XOR:  res = a ^ b;
        NOR:  res = ~(a | b);
        SLT:  begin
            f = (a_s < b_s) ? 1'b1 : 1'b0;
            res = {31'b0, f};
        end
        SLTU: begin
            f = (a < b) ? 1'b1 : 1'b0;
            res = {31'b0, f};
        end
        SLL:  res = b << shamt;
        SRL:  res = b >> shamt;
        SRA:  res = $signed(b_s) >>> shamt;
        SLLV: res = b << a[4:0];
        SRLV: res = b >> a[4:0];
        SRAV: res = $signed(b_s) >>> a[4:0];
        LUI:  res = b << 16; // shift b by 16 bits (standard MIPS LUI)
        default: begin
            res = 32'b0;
            c = 1'b0;
            o = 1'b0;
            f = 1'b0;
        end
    endcase

    r        = res;
    zero     = (res == 32'b0);
    carry    = ((aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU)) ? c : 1'b0;
    overflow = ((aluc == ADD) || (aluc == SUB)) ? o : 1'b0;
    negative = res[31];
    flag     = ((aluc == SLT) || (aluc == SLTU)) ? f : 1'b0;
end

endmodule