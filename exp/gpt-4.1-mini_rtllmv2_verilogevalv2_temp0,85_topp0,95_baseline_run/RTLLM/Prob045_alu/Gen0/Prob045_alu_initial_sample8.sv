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

    // Operation parameters
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

    // Signed versions of inputs for arithmetic and SLT
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;

    // Extended width for carry detection (33 bits)
    reg [32:0] add_res;
    reg [32:0] sub_res;

    // Shift amount extraction for variable shifts (5 bits)
    wire [4:0] shamt_a = a[4:0];
    wire [4:0] shamt_b = b[4:0]; // not used here, but for completeness

    always @(*) begin
        // Default assignments
        r = 32'bz;
        carry = 1'b0;
        overflow = 1'b0;
        negative = 1'b0;
        flag = 1'bz;

        case(aluc)
            ADD: begin
                add_res = {1'b0,a_signed} + {1'b0,b_signed};
                r = add_res[31:0];
                carry = add_res[32];
                // overflow detection for signed addition
                overflow = (~a_signed[31] & ~b_signed[31] & r[31]) | (a_signed[31] & b_signed[31] & ~r[31]);
                negative = r[31];
            end
            ADDU: begin
                add_res = {1'b0,a} + {1'b0,b};
                r = add_res[31:0];
                carry = add_res[32];
                overflow = 1'b0; // no overflow in unsigned add
                negative = r[31];
            end
            SUB: begin
                sub_res = {1'b0,a_signed} - {1'b0,b_signed};
                r = sub_res[31:0];
                // Carry here means borrow did not occur, so invert borrow for carry
                carry = ~sub_res[32];
                // overflow detection for signed subtraction
                overflow = (a_signed[31] & ~b_signed[31] & ~r[31]) | (~a_signed[31] & b_signed[31] & r[31]);
                negative = r[31];
            end
            SUBU: begin
                sub_res = {1'b0,a} - {1'b0,b};
                r = sub_res[31:0];
                carry = ~sub_res[32];
                overflow = 1'b0;
                negative = r[31];
            end
            AND: begin
                r = a & b;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            OR: begin
                r = a | b;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            XOR: begin
                r = a ^ b;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            NOR: begin
                r = ~(a | b);
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SLT: begin
                // Set flag and r = 1 if a_signed < b_signed else 0
                flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
                r = {31'b0, flag};
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SLTU: begin
                flag = (a < b) ? 1'b1 : 1'b0;
                r = {31'b0, flag};
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SLL: begin
                // shift left logical by b[4:0]
                r = b << a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SRL: begin
                // shift right logical by b[4:0]
                r = b >> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SRA: begin
                // shift right arithmetic by b[4:0]
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SLLV: begin
                // shift left logical by a[4:0]
                r = b << shamt_a;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SRLV: begin
                // shift right logical by a[4:0]
                r = b >> shamt_a;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            SRAV: begin
                // shift right arithmetic by a[4:0]
                r = $signed(b) >>> shamt_a;
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            LUI: begin
                // Load upper immediate: r = {b[15:0], 16'b0}
                r = {b[15:0],16'b0};
                carry = 1'b0;
                overflow = 1'b0;
                negative = r[31];
            end
            default: begin
                r = 32'bz;
                carry = 1'b0;
                overflow = 1'b0;
                negative = 1'b0;
                flag = 1'bz;
            end
        endcase
    end

    // zero flag: 1 if r == 0
    assign zero = (r == 32'b0);

endmodule