module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output wire [31:0] r,
    output wire        zero,
    output wire        carry,
    output wire        negative,
    output wire        overflow,
    output wire        flag
);

    // Opcodes as parameters
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

    // Intermediate results for operations
    wire [32:0] add_res = {1'b0, a} + {1'b0, b};
    wire [32:0] addu_res = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_res = {1'b0, a} - {1'b0, b};
    wire [32:0] subu_res = {1'b0, a} - {1'b0, b};

    wire [31:0] and_res = a & b;
    wire [31:0] or_res  = a | b;
    wire [31:0] xor_res = a ^ b;
    wire [31:0] nor_res = ~(a | b);

    wire slt_flag = (a_s < b_s);
    wire [31:0] slt_res = slt_flag ? 32'd1 : 32'd0;

    wire sltu_flag = (a < b);
    wire [31:0] sltu_res = sltu_flag ? 32'd1 : 32'd0;

    wire [31:0] sll_res = b << shamt;
    wire [31:0] srl_res = b >> shamt;
    wire [31:0] sra_res = $signed(b_s) >>> shamt;

    wire [31:0] sllv_res = b << a[4:0];
    wire [31:0] srlv_res = b >> a[4:0];
    wire [31:0] srav_res = $signed(b_s) >>> a[4:0];

    wire [31:0] lui_res = {a[15:0], 16'b0};

    // Default outputs for carry and overflow
    wire carry_add  = add_res[32];
    wire carry_addu = addu_res[32];
    wire carry_sub  = sub_res[32];
    wire carry_subu = subu_res[32];

    // Overflow detection for signed operations
    wire overflow_add = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
    wire overflow_sub = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

    // Selecting result based on aluc
    reg [31:0] r_reg;
    reg carry_reg;
    reg overflow_reg;
    reg flag_reg;

    always @(*) begin
        // Default values
        r_reg = 32'b0;
        carry_reg = 1'b0;
        overflow_reg = 1'b0;
        flag_reg = 1'b0;

        case(aluc)
            ADD: begin
                r_reg = add_res[31:0];
                carry_reg = carry_add;
                overflow_reg = overflow_add;
            end
            ADDU: begin
                r_reg = addu_res[31:0];
                carry_reg = carry_addu;
                overflow_reg = 1'b0;
            end
            SUB: begin
                r_reg = sub_res[31:0];
                carry_reg = carry_sub;
                overflow_reg = overflow_sub;
            end
            SUBU: begin
                r_reg = subu_res[31:0];
                carry_reg = carry_subu;
                overflow_reg = 1'b0;
            end
            AND: begin
                r_reg = and_res;
            end
            OR: begin
                r_reg = or_res;
            end
            XOR: begin
                r_reg = xor_res;
            end
            NOR: begin
                r_reg = nor_res;
            end
            SLT: begin
                r_reg = slt_res;
                flag_reg = slt_flag;
            end
            SLTU: begin
                r_reg = sltu_res;
                flag_reg = sltu_flag;
            end
            SLL: begin
                r_reg = sll_res;
            end
            SRL: begin
                r_reg = srl_res;
            end
            SRA: begin
                r_reg = sra_res;
            end
            SLLV: begin
                r_reg = sllv_res;
            end
            SRLV: begin
                r_reg = srlv_res;
            end
            SRAV: begin
                r_reg = srav_res;
            end
            LUI: begin
                r_reg = lui_res;
            end
            default: begin
                r_reg = 32'b0;
                carry_reg = 1'b0;
                overflow_reg = 1'b0;
                flag_reg = 1'b0;
            end
        endcase
    end

    assign r = r_reg;
    assign carry = carry_reg;
    assign overflow = overflow_reg;
    assign flag = flag_reg;
    assign zero = (r == 32'b0);
    assign negative = r[31];

endmodule