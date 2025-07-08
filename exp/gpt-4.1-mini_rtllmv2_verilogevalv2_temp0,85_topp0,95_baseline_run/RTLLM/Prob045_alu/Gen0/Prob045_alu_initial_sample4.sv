module alu (
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
    // Define ALU operation codes
    parameter ADD  = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB  = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND_ = 6'b100100; // renamed AND to AND_ to avoid keyword clash
    parameter OR_  = 6'b100101;
    parameter XOR_ = 6'b100110;
    parameter NOR_ = 6'b100111;
    parameter SLT  = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL  = 6'b000000;
    parameter SRL  = 6'b000010;
    parameter SRA  = 6'b000011;
    parameter SLLV = 6'b000100;
    parameter SRLV = 6'b000110;
    parameter SRAV = 6'b000111;
    parameter LUI  = 6'b001111;

    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;

    reg [32:0] add_sub_ext; // 33 bits to catch carry out
    reg [31:0] shift_result;
    reg slt_flag;
    reg sltu_flag;

    always @(*) begin
        carry = 1'b0;
        overflow = 1'b0;
        slt_flag = 1'b0;
        sltu_flag = 1'b0;
        case (aluc)
            ADD: begin
                add_sub_ext = {a[31], a} + {b[31], b};
                r = add_sub_ext[31:0];
                carry = add_sub_ext[32];
                // Overflow detection for signed addition
                overflow = (~a_s[31] & ~b_s[31] & r[31]) | (a_s[31] & b_s[31] & ~r[31]);
            end
            ADDU: begin
                add_sub_ext = {1'b0, a} + {1'b0, b};
                r = add_sub_ext[31:0];
                carry = add_sub_ext[32];
                overflow = 1'b0; // unsigned addition no overflow
            end
            SUB: begin
                add_sub_ext = {a[31], a} - {b[31], b};
                r = add_sub_ext[31:0];
                carry = (add_sub_ext[32] == 1'b0) ? 1'b1 : 1'b0; // borrow detection
                // Overflow detection for signed subtraction
                overflow = (a_s[31] & ~b_s[31] & ~r[31]) | (~a_s[31] & b_s[31] & r[31]);
            end
            SUBU: begin
                add_sub_ext = {1'b0, a} - {1'b0, b};
                r = add_sub_ext[31:0];
                carry = (add_sub_ext[32] == 1'b0) ? 1'b1 : 1'b0; // borrow detection
                overflow = 1'b0;
            end
            AND_: r = a & b;
            OR_:  r = a | b;
            XOR_: r = a ^ b;
            NOR_: r = ~(a | b);
            SLT: begin
                slt_flag = (a_s < b_s) ? 1'b1 : 1'b0;
                r = {31'b0, slt_flag};
            end
            SLTU: begin
                sltu_flag = (a < b) ? 1'b1 : 1'b0;
                r = {31'b0, sltu_flag};
            end
            SLL: r = b << a[4:0];
            SRL: r = b >> a[4:0];
            SRA: r = $signed(b) >>> a[4:0];
            SLLV: r = b << (a[4:0]);
            SRLV: r = b >> (a[4:0]);
            SRAV: r = $signed(b) >>> (a[4:0]);
            LUI: r = {b[15:0], 16'b0};
            default: r = 32'bz;
        endcase

        // negative flag from result sign bit
        negative = r[31];
    end

    assign zero = (r == 32'b0) ? 1'b1 : 1'b0;

    always @(*) begin
        case (aluc)
            SLT: flag = slt_flag;
            SLTU: flag = sltu_flag;
            default: flag = 1'bz;
        endcase
    end

endmodule