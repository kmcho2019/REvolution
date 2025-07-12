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
localparam ADD  = 6'b100000;
localparam ADDU = 6'b100001;
localparam SUB  = 6'b100010;
localparam SUBU = 6'b100011;
localparam AND  = 6'b100100;
localparam OR   = 6'b100101;
localparam XOR  = 6'b100110;
localparam NOR  = 6'b100111;
localparam SLT  = 6'b101010;
localparam SLTU = 6'b101011;
localparam SLL  = 6'b000000;
localparam SRL  = 6'b000010;
localparam SRA  = 6'b000011;
localparam SLLV = 6'b000100;
localparam SRLV = 6'b000110;
localparam SRAV = 6'b000111;
localparam LUI  = 6'b001111;

// Decode aluc once to one-hot flags for simpler conditions
wire is_ADD  = (aluc == ADD);
wire is_ADDU = (aluc == ADDU);
wire is_SUB  = (aluc == SUB);
wire is_SUBU = (aluc == SUBU);
wire is_AND  = (aluc == AND);
wire is_OR   = (aluc == OR);
wire is_XOR  = (aluc == XOR);
wire is_NOR  = (aluc == NOR);
wire is_SLT  = (aluc == SLT);
wire is_SLTU = (aluc == SLTU);
wire is_SLL  = (aluc == SLL);
wire is_SRL  = (aluc == SRL);
wire is_SRA  = (aluc == SRA);
wire is_SLLV = (aluc == SLLV);
wire is_SRLV = (aluc == SRLV);
wire is_SRAV = (aluc == SRAV);
wire is_LUI  = (aluc == LUI);

wire [4:0] shamt = a[4:0];

// Arithmetic extended results for carry/borrow detection
wire [32:0] add_ext = {1'b0, a} + {1'b0, b};
wire [32:0] sub_ext = {1'b0, a} - {1'b0, b};

// Signed versions for signed comparisons and overflow detection
wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;
wire signed [31:0] res_s;

// Temporary result for use in calculations
reg [31:0] res_tmp;
reg carry_tmp;
reg overflow_tmp;
reg flag_tmp;

always @* begin
    // Defaults
    res_tmp     = 32'b0;
    carry_tmp   = 1'b0;
    overflow_tmp= 1'b0;
    flag_tmp    = 1'b0;

    case (1'b1) // one-hot style case for clarity
        is_ADD: begin
            {carry_tmp, res_tmp} = add_ext;
            // Overflow: (a and b positive, result negative) or (a and b negative, result positive)
            overflow_tmp = (~a[31] & ~b[31] & res_tmp[31]) | (a[31] & b[31] & ~res_tmp[31]);
        end
        is_ADDU: begin
            {carry_tmp, res_tmp} = add_ext;
            overflow_tmp = 1'b0;
        end
        is_SUB: begin
            {carry_tmp, res_tmp} = sub_ext;
            // Overflow: (a negative, b positive, result positive) or (a positive, b negative, result negative)
            overflow_tmp = (a[31] & ~b[31] & ~res_tmp[31]) | (~a[31] & b[31] & res_tmp[31]);
        end
        is_SUBU: begin
            {carry_tmp, res_tmp} = sub_ext;
            overflow_tmp = 1'b0;
        end
        is_AND:  res_tmp = a & b;
        is_OR:   res_tmp = a | b;
        is_XOR:  res_tmp = a ^ b;
        is_NOR:  res_tmp = ~(a | b);
        is_SLT: begin
            flag_tmp = (a_s < b_s);
            res_tmp = {31'b0, flag_tmp};
        end
        is_SLTU: begin
            flag_tmp = (a < b);
            res_tmp = {31'b0, flag_tmp};
        end
        is_SLL:  res_tmp = b << shamt;
        is_SRL:  res_tmp = b >> shamt;
        is_SRA:  res_tmp = $signed(b) >>> shamt;
        is_SLLV: res_tmp = b << a[4:0];
        is_SRLV: res_tmp = b >> a[4:0];
        is_SRAV: res_tmp = $signed(b) >>> a[4:0];
        is_LUI:  res_tmp = {a[31:16], 16'b0}; // upper 16 bits concatenated with zeros
        default: begin
            res_tmp     = 32'b0;
            carry_tmp   = 1'b0;
            overflow_tmp= 1'b0;
            flag_tmp    = 1'b0;
        end
    endcase
end

always @* begin
    r        = res_tmp;
    carry    = carry_tmp;
    overflow = overflow_tmp;
    flag     = (is_SLT || is_SLTU) ? flag_tmp : 1'b0;
    zero     = (res_tmp == 32'b0);
    negative = res_tmp[31];
end

endmodule