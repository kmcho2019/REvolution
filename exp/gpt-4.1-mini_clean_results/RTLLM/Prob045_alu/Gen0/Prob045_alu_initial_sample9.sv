module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output wire        negative,
    output reg         overflow,
    output reg         flag
);

    // Opcode parameters
    parameter ADD  = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB  = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND_ = 6'b100100; // avoid macro conflict with "and"
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

    // Internal signals for arithmetic with carry and overflow detection
    reg [32:0] sum;
    reg [32:0] diff;
    wire [4:0] shamt = a[4:0];

    // signed versions for SLT and arithmetic overflow detection
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;

    always @(*) begin
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'bz;
        sum = 33'b0;
        diff = 33'b0;
        case (aluc)
            ADD: begin
                sum = {1'b0, a} + {1'b0, b};
                r = sum[31:0];
                carry = sum[32];
                // Overflow: if signs of a,b same but different sign from result
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            end
            ADDU: begin
                sum = {1'b0, a} + {1'b0, b};
                r = sum[31:0];
                carry = sum[32];
                overflow = 1'b0; // no overflow for unsigned add
            end
            SUB: begin
                diff = {1'b0, a} - {1'b0, b};
                r = diff[31:0];
                carry = ~diff[32]; // borrow flag: borrow = ~carry_out
                // Overflow detection: if a and b have different sign and result sign differs from a
                overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            end
            SUBU: begin
                diff = {1'b0, a} - {1'b0, b};
                r = diff[31:0];
                carry = ~diff[32]; // borrow flag
                overflow = 1'b0;
            end
            AND_:   r = a & b;
            OR_:    r = a | b;
            XOR_:   r = a ^ b;
            NOR_:   r = ~(a | b);
            SLT: begin
                flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
                r = {{31{1'b0}}, flag};
            end
            SLTU: begin
                flag = (a < b) ? 1'b1 : 1'b0;
                r = {{31{1'b0}}, flag};
            end
            SLL:    r = b << a[4:0];
            SRL:    r = b >> a[4:0];
            SRA:    r = $signed(b) >>> a[4:0];
            SLLV:   r = b << shamt;
            SRLV:   r = b >> shamt;
            SRAV:   r = $signed(b) >>> shamt;
            LUI:    r = {b[15:0],16'b0};
            default: begin
                r = 32'bz;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
        endcase
    end

    assign zero = (r == 32'b0);
    assign negative = r[31];

endmodule