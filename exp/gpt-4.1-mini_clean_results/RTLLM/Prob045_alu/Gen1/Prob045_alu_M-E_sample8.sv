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

    // Intermediate wires for operations
    wire signed [31:0] a_s = $signed(a);
    wire signed [31:0] b_s = $signed(b);
    wire [4:0] shamt = a[4:0];

    // Arithmetic with carry detection
    wire [32:0] sum_add  = {1'b0, a} + {1'b0, b};
    wire [32:0] sum_addu = {1'b0, a} + {1'b0, b};
    wire [32:0] diff_sub  = {1'b0, a} - {1'b0, b};
    wire [32:0] diff_subu = {1'b0, a} - {1'b0, b};

    // Flags for add/sub overflow detection
    wire add_overflow  = (~a[31] & ~b[31] & sum_add[31]) | (a[31] & b[31] & ~sum_add[31]);
    wire sub_overflow  = (a[31] & ~b[31] & ~diff_sub[31]) | (~a[31] & b[31] & diff_sub[31]);

    // Compute all possible results
    wire [31:0] res_add  = sum_add[31:0];
    wire [31:0] res_addu = sum_addu[31:0];
    wire [31:0] res_sub  = diff_sub[31:0];
    wire [31:0] res_subu = diff_subu[31:0];
    wire [31:0] res_and  = a & b;
    wire [31:0] res_or   = a | b;
    wire [31:0] res_xor  = a ^ b;
    wire [31:0] res_nor  = ~(a | b);
    wire [31:0] res_sll  = b << shamt;
    wire [31:0] res_srl  = b >> shamt;
    wire [31:0] res_sra  = $signed(b) >>> shamt;
    wire [31:0] res_sllv = b << shamt;
    wire [31:0] res_srlv = b >> shamt;
    wire [31:0] res_srav = $signed(b) >>> shamt;
    wire [31:0] res_lui  = {b[15:0], 16'b0};
    wire       flag_slt  = (a_s < b_s);
    wire       flag_sltu = (a < b);

    always @* begin
        // Defaults
        r        = 32'b0;
        carry    = 1'b0;
        negative = 1'b0;
        overflow = 1'b0;
        flag     = 1'b0;

        case (aluc)
            ADD: begin
                r        = res_add;
                carry    = sum_add[32];
                overflow = add_overflow;
                negative = r[31];
                flag     = 1'b0;
            end
            ADDU: begin
                r        = res_addu;
                carry    = sum_addu[32];
                overflow = 1'b0;
                negative = r[31];
                flag     = 1'b0;
            end
            SUB: begin
                r        = res_sub;
                carry    = ~diff_sub[32]; // borrow flag inverted for carry
                overflow = sub_overflow;
                negative = r[31];
                flag     = 1'b0;
            end
            SUBU: begin
                r        = res_subu;
                carry    = ~diff_subu[32];
                overflow = 1'b0;
                negative = r[31];
                flag     = 1'b0;
            end
            AND: begin
                r        = res_and;
                carry    = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag     = 1'b0;
            end
            OR: begin
                r        = res_or;
                carry    = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag     = 1'b0;
            end
            XOR: begin
                r        = res_xor;
                carry    = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag     = 1'b0;
            end
            NOR: begin
                r        = res_nor;
                carry    = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag     = 1'b0;
            end
            SLT: begin
                flag     = flag_slt ? 1'b1 : 1'b0;
                r        = {31'b0, flag};
                carry    = 1'b0;
                overflow = 1'b0;
                negative = 1'b0;
            end
            SLTU: begin
                flag     = flag_sltu ? 1'b1 : 1'b0;
                r        = {31'b0, flag};
                carry    = 1'b0;
                overflow = 1'b0;
                negative = 1'b0;
            end
            SLL: begin
                r        = res_sll;
                carry    = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag     = 1'b0;
            end
            SRL: begin
                r        = res_srl;
                carry    = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag     = 1'b0;
            end
            SRA: begin
                r        = res_sra;
                carry    = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag     = 1'b0;
            end
            SLLV: begin
                r        = res_sllv;
                carry    = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag     = 1'b0;
            end
            SRLV: begin
                r        = res_srlv;
                carry    = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag     = 1'b0;
            end
            SRAV: begin
                r        = res_srav;
                carry    = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag     = 1'b0;
            end
            LUI: begin
                r        = res_lui;
                carry    = 1'b0;
                overflow = 1'b0;
                negative = r[31];
                flag     = 1'b0;
            end
            default: begin
                r        = 32'b0;
                carry    = 1'b0;
                overflow = 1'b0;
                negative = 1'b0;
                flag     = 1'b0;
            end
        endcase
    end

    assign zero = (r == 32'b0);

endmodule