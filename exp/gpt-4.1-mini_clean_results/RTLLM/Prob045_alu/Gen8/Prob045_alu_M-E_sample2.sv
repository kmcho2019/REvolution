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

    wire [4:0] shamt_imm  = a[4:0];
    wire [4:0] shamt_var  = a[4:0];

    // Arithmetic results (add/sub)
    wire [32:0] add_res_ext = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_res_ext = {1'b0, a} - {1'b0, b};

    wire [31:0] add_res = add_res_ext[31:0];
    wire [31:0] sub_res = sub_res_ext[31:0];

    wire        add_carry = add_res_ext[32];
    wire        sub_carry = sub_res_ext[32];

    wire signed [31:0] a_signed = $signed(a);
    wire signed [31:0] b_signed = $signed(b);

    // Overflow detection for add
    wire add_overflow = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
    // Overflow detection for sub
    wire sub_overflow = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

    // Logic operations
    wire [31:0] and_res = a & b;
    wire [31:0] or_res  = a | b;
    wire [31:0] xor_res = a ^ b;
    wire [31:0] nor_res = ~(a | b);

    // Shift operations
    wire [31:0] sll_res  = b << shamt_imm;
    wire [31:0] srl_res  = b >> shamt_imm;
    wire [31:0] sra_res  = $signed(b) >>> shamt_imm;
    wire [31:0] sllv_res = b << shamt_var;
    wire [31:0] srlv_res = b >> shamt_var;
    wire [31:0] srav_res = $signed(b) >>> shamt_var;

    // SLT and SLTU flags and results
    wire slt_flag  = (a_signed < b_signed);
    wire sltu_flag = (a < b);

    // LUI result: upper 16 bits loaded with lower 16 bits of 'a', lower 16 bits zero
    wire [31:0] lui_res = {a[15:0], 16'b0};

    // Intermediate result and flags
    reg [31:0] r_arith;   // arithmetic result
    reg        c_arith;   // carry from arithmetic
    reg        ov_arith;  // overflow from arithmetic
    reg        arith_valid;

    always @* begin
        // Default outputs
        r = 32'bz;  // high impedance default for undefined ops
        carry = 1'b0;
        overflow = 1'b0;
        negative = 1'b0;
        zero = 1'b0;
        flag = 1'bz; // high impedance when not SLT/SLTU
        arith_valid = 1'b0;
        r_arith = 32'b0;
        c_arith = 1'b0;
        ov_arith = 1'b0;

        case (aluc)
            // Arithmetic operations
            ADD: begin
                r_arith = add_res;
                c_arith = add_carry;
                ov_arith = add_overflow;
                arith_valid = 1'b1;
            end
            ADDU: begin
                r_arith = add_res;
                c_arith = add_carry;
                ov_arith = 1'b0;
                arith_valid = 1'b1;
            end
            SUB: begin
                r_arith = sub_res;
                c_arith = sub_carry;
                ov_arith = sub_overflow;
                arith_valid = 1'b1;
            end
            SUBU: begin
                r_arith = sub_res;
                c_arith = sub_carry;
                ov_arith = 1'b0;
                arith_valid = 1'b1;
            end

            // Logic operations
            AND: r = and_res;
            OR:  r = or_res;
            XOR: r = xor_res;
            NOR: r = nor_res;

            // Set less than signed/unsigned
            SLT: begin
                flag = slt_flag ? 1'b1 : 1'b0;
                r = {31'b0, flag};
            end
            SLTU: begin
                flag = sltu_flag ? 1'b1 : 1'b0;
                r = {31'b0, flag};
            end

            // Shift operations
            SLL:  r = sll_res;
            SRL:  r = srl_res;
            SRA:  r = sra_res;
            SLLV: r = sllv_res;
            SRLV: r = srlv_res;
            SRAV: r = srav_res;

            // LUI
            LUI:  r = lui_res;

            // Default undefined operation
            default: begin
                r = 32'bz;
                flag = 1'bz;
            end
        endcase

        // If arithmetic operation selected, override r and flags accordingly
        if (arith_valid) begin
            r = r_arith;
            carry = c_arith;
            overflow = ov_arith;
            flag = 1'bz; // flag not valid for arithmetic ops
        end else begin
            // For non-arithmetic ops, clear carry and overflow to 0
            carry = 1'b0;
            overflow = 1'b0;
        end

        // Zero and negative flag depend on final r
        zero = (r === 32'b0);
        negative = r[31];
    end

endmodule