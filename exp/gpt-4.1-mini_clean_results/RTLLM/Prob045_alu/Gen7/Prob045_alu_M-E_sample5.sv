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

    wire [4:0] shamt = a[4:0];         // shift amount for fixed shifts
    wire [4:0] shamt_var = a[4:0];     // shift amount for variable shifts

    // Arithmetic add/subtract with carry
    wire [32:0] add_res = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_res = {1'b0, a} - {1'b0, b};

    // Logical operations
    wire [31:0] and_res = a & b;
    wire [31:0] or_res  = a | b;
    wire [31:0] xor_res = a ^ b;
    wire [31:0] nor_res = ~(a | b);

    // Shift operations
    wire [31:0] sll_res  = b << shamt;
    wire [31:0] srl_res  = b >> shamt;
    wire [31:0] sra_res  = $signed(b_s) >>> shamt;
    wire [31:0] sllv_res = b << shamt_var;
    wire [31:0] srlv_res = b >> shamt_var;
    wire [31:0] srav_res = $signed(b_s) >>> shamt_var;

    // LUI operation: upper 16 bits of a concatenated with 16 zeros (per spec)
    wire [31:0] lui_res = {a[31:16], 16'b0};

    // Flag computations for SLT and SLTU
    wire slt_flag  = (a_s < b_s);
    wire sltu_flag = (a < b);

    always @(*) begin
        // Defaults
        r        <= 32'bz;  // high impedance for undefined opcode as requested
        zero     <= 1'b0;
        carry    <= 1'b0;
        negative <= 1'b0;
        overflow <= 1'b0;
        flag     <= 1'bz;   // 'z' when flag not applicable

        case(aluc)
            ADD: begin
                r        <= add_res[31:0];
                carry    <= add_res[32];
                // Overflow detection: if signs of a and b are same but differ from result
                overflow <= (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
                flag     <= 1'b0;
            end

            ADDU: begin
                r        <= add_res[31:0];
                carry    <= add_res[32];
                overflow <= 1'b0; // no overflow in unsigned add
                flag     <= 1'b0;
            end

            SUB: begin
                r        <= sub_res[31:0];
                carry    <= sub_res[32]; // carry = borrow in subtraction
                // Overflow detection for signed subtraction
                overflow <= (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
                flag     <= 1'b0;
            end

            SUBU: begin
                r        <= sub_res[31:0];
                carry    <= sub_res[32];
                overflow <= 1'b0;
                flag     <= 1'b0;
            end

            AND: begin
                r        <= and_res;
                carry    <= 1'b0;
                overflow <= 1'b0;
                flag     <= 1'b0;
            end

            OR: begin
                r        <= or_res;
                carry    <= 1'b0;
                overflow <= 1'b0;
                flag     <= 1'b0;
            end

            XOR: begin
                r        <= xor_res;
                carry    <= 1'b0;
                overflow <= 1'b0;
                flag     <= 1'b0;
            end

            NOR: begin
                r        <= nor_res;
                carry    <= 1'b0;
                overflow <= 1'b0;
                flag     <= 1'b0;
            end

            SLT: begin
                flag     <= slt_flag ? 1'b1 : 1'b0;
                r        <= 32'b0;
                r[0]     <= slt_flag ? 1'b1 : 1'b0;
                carry    <= 1'b0;
                overflow <= 1'b0;
            end

            SLTU: begin
                flag     <= sltu_flag ? 1'b1 : 1'b0;
                r        <= 32'b0;
                r[0]     <= sltu_flag ? 1'b1 : 1'b0;
                carry    <= 1'b0;
                overflow <= 1'b0;
            end

            SLL: begin
                r        <= sll_res;
                carry    <= 1'b0;
                overflow <= 1'b0;
                flag     <= 1'b0;
            end

            SRL: begin
                r        <= srl_res;
                carry    <= 1'b0;
                overflow <= 1'b0;
                flag     <= 1'b0;
            end

            SRA: begin
                r        <= sra_res;
                carry    <= 1'b0;
                overflow <= 1'b0;
                flag     <= 1'b0;
            end

            SLLV: begin
                r        <= sllv_res;
                carry    <= 1'b0;
                overflow <= 1'b0;
                flag     <= 1'b0;
            end

            SRLV: begin
                r        <= srlv_res;
                carry    <= 1'b0;
                overflow <= 1'b0;
                flag     <= 1'b0;
            end

            SRAV: begin
                r        <= srav_res;
                carry    <= 1'b0;
                overflow <= 1'b0;
                flag     <= 1'b0;
            end

            LUI: begin
                r        <= lui_res;
                carry    <= 1'b0;
                overflow <= 1'b0;
                flag     <= 1'b0;
            end

            default: begin
                r        <= 32'bz;
                carry    <= 1'b0;
                overflow <= 1'b0;
                flag     <= 1'bz;
            end
        endcase

        zero <= (r === 32'b0) ? 1'b1 : 1'b0;
        negative <= (r[31] === 1'b1) ? 1'b1 : 1'b0;
    end

endmodule