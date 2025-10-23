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
    // Define parameters for ALU control signals
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

    // Signed versions of inputs for SLT and SRA/SRAV
    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;

    // Intermediate results for addition and subtraction with carry/borrow detection
    reg [32:0] add_res;
    reg [32:0] sub_res;

    // Internal flag for signed overflow detection
    wire add_overflow;
    wire sub_overflow;

    // Signed overflow occurs when sign(a) == sign(b) and sign(result) != sign(a)
    assign add_overflow = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
    // For subtraction: overflow if sign(a) != sign(b) and sign(result) != sign(a)
    assign sub_overflow = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

    always @(*) begin
        // Default assignments
        r = 32'd0;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;  // default no flag set, no tri-state

        case(aluc)
            ADD, ADDU: begin
                add_res = {1'b0, a} + {1'b0, b};
                r = add_res[31:0];
                carry = add_res[32];
                overflow = (aluc == ADD) ? add_overflow : 1'b0;
                flag = 1'b0;
            end
            SUB, SUBU: begin
                sub_res = {1'b0, a} - {1'b0, b};
                r = sub_res[31:0];
                carry = ~sub_res[32]; // borrow is inverted carry
                overflow = (aluc == SUB) ? sub_overflow : 1'b0;
                flag = 1'b0;
            end
            AND: begin
                r = a & b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            OR: begin
                r = a | b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            XOR: begin
                r = a ^ b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            NOR: begin
                r = ~(a | b);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            SLT: begin
                r = (a_s < b_s) ? 32'd1 : 32'd0;
                carry = 1'b0;
                overflow = 1'b0;
                flag = (a_s < b_s) ? 1'b1 : 1'b0;
            end
            SLTU: begin
                r = (a < b) ? 32'd1 : 32'd0;
                carry = 1'b0;
                overflow = 1'b0;
                flag = (a < b) ? 1'b1 : 1'b0;
            end
            SLL: begin
                // Shift b left logical by a[4:0]
                r = b << a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            SRL: begin
                // Shift b right logical by a[4:0]
                r = b >> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            SRA: begin
                // Arithmetic right shift b by a[4:0]
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            SLLV: begin
                r = b << a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            SRLV: begin
                r = b >> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            SRAV: begin
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            LUI: begin
                // Load upper immediate: b[15:0] placed in upper 16 bits of r, lower 16 bits zero
                r = {b[15:0], 16'b0};
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            default: begin
                r = 32'd0;      // default zero to avoid latches/tri-state
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
        endcase
    end

    // Combinational assignments for zero and negative flags
    assign zero = (r == 32'd0);
    assign negative = r[31];

endmodule