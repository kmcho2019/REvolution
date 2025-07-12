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

    wire [4:0] shamt = a[4:0];
    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;

    reg [32:0] add_ext;
    reg [32:0] sub_ext;
    reg [31:0] alu_result;
    reg       slt_flag;

    always @(*) begin
        // Defaults
        alu_result = 32'b0;
        carry      = 1'b0;
        overflow   = 1'b0;
        flag       = 1'b0;

        // Compute extended add/sub results for carry and overflow detection
        add_ext = {1'b0, a} + {1'b0, b};
        sub_ext = {1'b0, a} - {1'b0, b};

        case (aluc)
            ADD: begin
                alu_result = add_ext[31:0];
                carry = add_ext[32];
                // Overflow when sign of operands equal but sign of result differs
                overflow = (~a[31] & ~b[31] & alu_result[31]) | (a[31] & b[31] & ~alu_result[31]);
            end

            ADDU: begin
                alu_result = add_ext[31:0];
                carry = add_ext[32];
                overflow = 1'b0;
            end

            SUB: begin
                alu_result = sub_ext[31:0];
                // Carry for SUB interpreted as borrow: carry=1 if no borrow
                carry = ~sub_ext[32];
                overflow = (a[31] & ~b[31] & ~alu_result[31]) | (~a[31] & b[31] & alu_result[31]);
            end

            SUBU: begin
                alu_result = sub_ext[31:0];
                carry = ~sub_ext[32];
                overflow = 1'b0;
            end

            AND: alu_result = a & b;

            OR:  alu_result = a | b;

            XOR: alu_result = a ^ b;

            NOR: alu_result = ~(a | b);

            SLT: begin
                slt_flag = (a_s < b_s);
                alu_result = slt_flag ? 32'd1 : 32'd0;
                flag = slt_flag;
            end

            SLTU: begin
                slt_flag = (a < b);
                alu_result = slt_flag ? 32'd1 : 32'd0;
                flag = slt_flag;
            end

            SLL:  alu_result = b << shamt;

            SRL:  alu_result = b >> shamt;

            SRA:  alu_result = $signed(b) >>> shamt;

            SLLV: alu_result = b << shamt;

            SRLV: alu_result = b >> shamt;

            SRAV: alu_result = $signed(b) >>> shamt;

            LUI:  alu_result = {a[15:0], 16'b0};

            default: begin
                alu_result = 32'bz;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
        endcase

        r = alu_result;
        zero = (alu_result == 32'b0);
        negative = alu_result[31];
        if (!(aluc == SLT || aluc == SLTU))
            flag = 1'b0;  // ensure flag is 0 for other ops
    end

endmodule