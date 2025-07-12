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

    // Opcodes
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

    wire [4:0] shamt = a[4:0]; // shift amount from a[4:0]
    wire signed [31:0] a_s = $signed(a);
    wire signed [31:0] b_s = $signed(b);

    // Compute all results upfront
    wire [32:0] add_wide = {1'b0, a} + {1'b0, b};
    wire [32:0] addu_wide = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_wide = {1'b0, a} - {1'b0, b};
    wire [32:0] subu_wide = {1'b0, a} - {1'b0, b};

    wire [31:0] and_res  = a & b;
    wire [31:0] or_res   = a | b;
    wire [31:0] xor_res  = a ^ b;
    wire [31:0] nor_res  = ~(a | b);
    wire        slt_flag = (a_s < b_s) ? 1'b1 : 1'b0;
    wire        sltu_flag= (a < b)    ? 1'b1 : 1'b0;
    wire [31:0] slt_res  = {31'b0, slt_flag};
    wire [31:0] sltu_res = {31'b0, sltu_flag};
    wire [31:0] sll_res  = b << shamt;
    wire [31:0] srl_res  = b >> shamt;
    wire [31:0] sra_res  = $signed(b_s) >>> shamt;
    wire [31:0] sllv_res = b << a[4:0];
    wire [31:0] srlv_res = b >> a[4:0];
    wire [31:0] srav_res = $signed(b_s) >>> a[4:0];
    wire [31:0] lui_res  = {a[15:0], 16'b0};

    // Carry and overflow for ADD/SUB
    wire add_carry = add_wide[32];
    wire addu_carry= addu_wide[32];
    wire sub_carry = sub_wide[32];   // In subtraction, carry is borrow inverted
    wire subu_carry= subu_wide[32];

    wire add_overflow  = (~a[31] & ~b[31] & add_wide[31]) | (a[31] & b[31] & ~add_wide[31]);
    wire sub_overflow  = (a[31] & ~b[31] & ~sub_wide[31]) | (~a[31] & b[31] & sub_wide[31]);

    // Default wires for outputs
    reg [31:0] r_nxt;
    reg carry_nxt;
    reg overflow_nxt;
    reg flag_nxt;
    reg flag_z; // 1 means high impedance 'z'

    always @* begin
        // Defaults
        r_nxt = 32'b0;
        carry_nxt = 1'b0;
        overflow_nxt = 1'b0;
        flag_nxt = 1'b0;
        flag_z = 1'b0;

        case(aluc)
            ADD: begin
                r_nxt = add_wide[31:0];
                carry_nxt = add_carry;
                overflow_nxt = add_overflow;
            end
            ADDU: begin
                r_nxt = addu_wide[31:0];
                carry_nxt = addu_carry;
                overflow_nxt = 1'b0;
            end
            SUB: begin
                r_nxt = sub_wide[31:0];
                carry_nxt = sub_carry;
                overflow_nxt = sub_overflow;
            end
            SUBU: begin
                r_nxt = subu_wide[31:0];
                carry_nxt = subu_carry;
                overflow_nxt = 1'b0;
            end
            AND: r_nxt = and_res;
            OR:  r_nxt = or_res;
            XOR: r_nxt = xor_res;
            NOR: r_nxt = nor_res;
            SLT: begin
                r_nxt = slt_res;
                flag_nxt = slt_flag;
                flag_z = 1'b0;
            end
            SLTU: begin
                r_nxt = sltu_res;
                flag_nxt = sltu_flag;
                flag_z = 1'b0;
            end
            SLL:  r_nxt = sll_res;
            SRL:  r_nxt = srl_res;
            SRA:  r_nxt = sra_res;
            SLLV: r_nxt = sllv_res;
            SRLV: r_nxt = srlv_res;
            SRAV: r_nxt = srav_res;
            LUI:  r_nxt = lui_res;
            default: begin
                // Output undefined - high impedance on r and flag
                r_nxt = 32'bz;
                flag_z = 1'b1;
            end
        endcase

        // If flag_z asserted, assign high impedance to flag, else flag_nxt
    end

    // Output assignments
    always @* begin
        r = r_nxt;
        carry = carry_nxt;
        overflow = overflow_nxt;
        zero = (r == 32'b0);
        negative = r[31];

        if(flag_z)
            flag = 1'bz; // high impedance when not SLT/SLTU
        else
            flag = flag_nxt;
    end

endmodule