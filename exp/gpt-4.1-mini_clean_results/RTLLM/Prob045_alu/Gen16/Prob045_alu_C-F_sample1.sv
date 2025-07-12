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

    // Signed operands for signed operations
    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;

    reg [32:0] arith_res_ext; // 33-bit extended for carry detection

    always @* begin
        // Default assignments
        r = 32'b0;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;

        case (aluc)
            ADD: begin
                arith_res_ext = {1'b0, a} + {1'b0, b};
                r = arith_res_ext[31:0];
                carry = arith_res_ext[32];
                // Overflow: if signs of a and b same, but sign of result differs
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            end

            ADDU: begin
                arith_res_ext = {1'b0, a} + {1'b0, b};
                r = arith_res_ext[31:0];
                carry = arith_res_ext[32];
                overflow = 1'b0; // No overflow for unsigned add
            end

            SUB: begin
                arith_res_ext = {1'b0, a} - {1'b0, b};
                r = arith_res_ext[31:0];
                carry = arith_res_ext[32];
                // Overflow: if signs of a and b differ and sign of result differs from a
                overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            end

            SUBU: begin
                arith_res_ext = {1'b0, a} - {1'b0, b};
                r = arith_res_ext[31:0];
                carry = arith_res_ext[32];
                overflow = 1'b0; // No overflow for unsigned sub
            end

            AND: r = a & b;
            OR:  r = a | b;
            XOR: r = a ^ b;
            NOR: r = ~(a | b);

            SLT: begin
                flag = (a_s < b_s) ? 1'b1 : 1'b0;
                r = {31'b0, flag};
            end

            SLTU: begin
                flag = (a < b) ? 1'b1 : 1'b0;
                r = {31'b0, flag};
            end

            SLL:  r = b << shamt;
            SRL:  r = b >> shamt;
            SRA:  r = $signed(b) >>> shamt;
            SLLV: r = b << a[4:0];
            SRLV: r = b >> a[4:0];
            SRAV: r = $signed(b) >>> a[4:0];

            LUI: r = {a[15:0], 16'b0};

            default: begin
                r = 32'b0;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
        endcase

        zero = (r == 32'b0);
        negative = r[31];
    end

endmodule