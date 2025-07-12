module alu (
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output negative,
    output reg overflow,
    output reg flag
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

    // Extract shift amount from a (lowest 5 bits)
    wire [4:0] shamt = a[4:0];
    wire signed [31:0] a_s = $signed(a);
    wire signed [31:0] b_s = $signed(b);

    // Prepare signals for arithmetic operations using a single wide adder approach
    // For SUB and SUBU, invert b and add 1 (two's complement)
    wire sub_op = (aluc == SUB) || (aluc == SUBU);

    // Generate operand B for adder: b or ~b+1 depending on op
    wire [31:0] b_adj = sub_op ? ~b : b;
    wire carry_in = sub_op ? 1'b1 : 1'b0;

    // 33-bit adder to capture carry out
    wire [32:0] adder_out = {1'b0, a} + {1'b0, b_adj} + carry_in;

    wire [31:0] sum = adder_out[31:0];
    wire carry_out = adder_out[32];

    // Determine signed overflow:
    // overflow = (sign of a == sign of b_adj) and (sign of sum != sign of a)
    wire overflow_sig = (~a[31] & ~b_adj[31] & sum[31]) | (a[31] & b_adj[31] & ~sum[31]);

    // For carry flag:
    // ADDU: carry = carry_out
    // SUBU: carry = ~carry_out (borrow flag)
    // Other operations: carry = 0
    wire carry_flag = (aluc == ADDU) ? carry_out :
                      (aluc == SUBU) ? ~carry_out : 1'b0;

    // For flag output (slt and sltu), otherwise high-impedance
    reg flag_out;
    reg flag_en;

    always @(*) begin
        // Default assignments
        r = 32'b0;
        carry = 1'b0;
        overflow = 1'b0;
        flag_out = 1'bz;
        flag_en = 1'b0;

        case (aluc)
            ADD: begin
                r = sum;
                overflow = overflow_sig;
                carry = 1'b0;
            end
            ADDU: begin
                r = sum;
                carry = carry_flag;
                overflow = 1'b0;
            end
            SUB: begin
                r = sum;
                overflow = overflow_sig;
                carry = 1'b0;
            end
            SUBU: begin
                r = sum;
                carry = carry_flag;
                overflow = 1'b0;
            end
            AND: r = a & b;
            OR:  r = a | b;
            XOR: r = a ^ b;
            NOR: r = ~(a | b);

            SLT: begin
                // flag and r set if signed less than
                flag_out = (a_s < b_s) ? 1'b1 : 1'b0;
                flag_en = 1'b1;
                r = flag_out ? 32'd1 : 32'd0;
            end
            SLTU: begin
                // flag and r set if unsigned less than
                flag_out = (a < b) ? 1'b1 : 1'b0;
                flag_en = 1'b1;
                r = flag_out ? 32'd1 : 32'd0;
            end

            SLL:  r = b << shamt;
            SLLV: r = b << (a[4:0]);
            SRL:  r = b >> shamt;
            SRLV: r = b >> (a[4:0]);
            SRA:  r = $signed(b) >>> shamt;
            SRAV: r = $signed(b) >>> (a[4:0]);

            LUI:  r = {a[31:16], 16'b0};

            default: begin
                // For undefined opcodes, drive outputs to high-impedance per spec for flag
                r = 32'bz;
                carry = 1'b0;
                overflow = 1'b0;
                flag_out = 1'bz;
            end
        endcase

        // Assign flag only when SLT or SLTU; else high-Z
        if(flag_en)
            flag = flag_out;
        else
            flag = 1'bz;
    end

    // Combinational outputs
    assign zero = (r == 32'b0);
    assign negative = r[31];

endmodule