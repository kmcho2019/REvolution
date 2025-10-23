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

    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;

    reg [32:0] arith_ext;  // 33 bits for carry detection
    reg [31:0] logic_res;
    reg [31:0] shift_res;
    reg        slt_flag;
    reg [31:0] slt_res;

    always @* begin
        // Default assignments
        r = 32'd0;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
        negative = 1'b0;

        arith_ext = 33'd0;
        logic_res = 32'd0;
        shift_res = 32'd0;
        slt_flag = 1'b0;
        slt_res = 32'd0;

        case (aluc)
            // Arithmetic operations
            ADD: begin
                arith_ext = {1'b0, a} + {1'b0, b};
                r = arith_ext[31:0];
                carry = arith_ext[32];
                // Overflow occurs if signs of a and b same but different from result
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            end
            ADDU: begin
                arith_ext = {1'b0, a} + {1'b0, b};
                r = arith_ext[31:0];
                carry = arith_ext[32];
                overflow = 1'b0; // Unsigned add no overflow flag
            end
            SUB: begin
                arith_ext = {1'b0, a} - {1'b0, b};
                r = arith_ext[31:0];
                carry = arith_ext[32]; // borrow flag: 1 means no borrow, 0 means borrow occurred
                // Overflow occurs if signs of a and b differ and result sign differs from a
                overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            end
            SUBU: begin
                arith_ext = {1'b0, a} - {1'b0, b};
                r = arith_ext[31:0];
                carry = arith_ext[32];
                overflow = 1'b0; // Unsigned sub no overflow flag
            end

            // Logical operations
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);

            // Set on less than
            SLT: begin
                slt_flag = (a_s < b_s) ? 1'b1 : 1'b0;
                r = {31'd0, slt_flag};
                flag = slt_flag;
            end
            SLTU: begin
                slt_flag = (a < b) ? 1'b1 : 1'b0;
                r = {31'd0, slt_flag};
                flag = slt_flag;
            end

            // Shift operations
            SLL:  r = b << shamt;
            SRL:  r = b >> shamt;
            SRA:  r = b_s >>> shamt;
            SLLV: r = b << a[4:0];
            SRLV: r = b >> a[4:0];
            SRAV: r = b_s >>> a[4:0];

            // Load Upper Immediate (LUI)
            LUI:  r = {a[15:0], 16'b0};

            default: begin
                r = 32'd0;
                flag = 1'b0;
                carry = 1'b0;
                overflow = 1'b0;
            end
        endcase

        negative = r[31];
    end

    assign zero = (r == 32'd0);

endmodule