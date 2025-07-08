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

    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;
    wire [4:0] shamt = a[4:0]; // shift amount from a for variable shifts

    wire [32:0] add_result = {1'b0, a} + {1'b0, b};
    wire [32:0] addu_result = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_result = {1'b0, a} - {1'b0, b};
    wire [32:0] subu_result = {1'b0, a} - {1'b0, b};

    always @(*) begin
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'bz;
        case(aluc)
            ADD: begin
                r = a_s + b_s;
                // overflow detection for signed addition
                overflow = (~a_s[31] & ~b_s[31] & r[31]) | (a_s[31] & b_s[31] & ~r[31]);
                carry = add_result[32];
            end
            ADDU: begin
                r = a + b;
                carry = addu_result[32];
                overflow = 1'b0;
            end
            SUB: begin
                r = a_s - b_s;
                // overflow detection for signed subtraction
                overflow = (a_s[31] & ~b_s[31] & ~r[31]) | (~a_s[31] & b_s[31] & r[31]);
                carry = ~subu_result[32]; // borrow flag inverted carry out (1 means no borrow)
            end
            SUBU: begin
                r = a - b;
                carry = ~subu_result[32];
                overflow = 1'b0;
            end
            AND: begin
                r = a & b;
            end
            OR: begin
                r = a | b;
            end
            XOR: begin
                r = a ^ b;
            end
            NOR: begin
                r = ~(a | b);
            end
            SLT: begin
                // signed comparison
                r = (a_s < b_s) ? 32'd1 : 32'd0;
                flag = r[0];
            end
            SLTU: begin
                // unsigned comparison
                r = (a < b) ? 32'd1 : 32'd0;
                flag = r[0];
            end
            SLL: begin
                r = b << a[4:0];
            end
            SRL: begin
                r = b >> a[4:0];
            end
            SRA: begin
                r = $signed(b) >>> a[4:0];
            end
            SLLV: begin
                r = b << shamt;
            end
            SRLV: begin
                r = b >> shamt;
            end
            SRAV: begin
                r = $signed(b) >>> shamt;
            end
            LUI: begin
                r = {b[15:0], 16'b0};
            end
            default: begin
                r = 32'bz;
            end
        endcase
    end

    assign zero = (r == 32'b0);
    assign negative = r[31];

endmodule