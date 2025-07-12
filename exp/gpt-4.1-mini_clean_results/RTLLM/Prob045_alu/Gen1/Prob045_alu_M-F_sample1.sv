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

    // Signed versions of inputs
    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;

    // Temporary registers for extended results (carry/borrow detection)
    reg [32:0] add_result;
    reg [32:0] sub_result;

    always @(*) begin
        // Default assignments
        r = 32'b0;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;

        case(aluc)
            ADD: begin
                add_result = {1'b0, a} + {1'b0, b};
                r = add_result[31:0];
                carry = add_result[32];
                // Overflow occurs if sign(a)==sign(b) and sign(r)!=sign(a)
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
                flag = 1'b0;
            end
            ADDU: begin
                add_result = {1'b0, a} + {1'b0, b};
                r = add_result[31:0];
                carry = add_result[32];
                overflow = 1'b0; // no overflow for unsigned add
                flag = 1'b0;
            end
            SUB: begin
                sub_result = {1'b0, a} - {1'b0, b};
                r = sub_result[31:0];
                carry = ~sub_result[32]; // borrow indication inverted carry
                // Overflow if sign(a)!=sign(b) and sign(r)!=sign(a)
                overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
                flag = 1'b0;
            end
            SUBU: begin
                sub_result = {1'b0, a} - {1'b0, b};
                r = sub_result[31:0];
                carry = ~sub_result[32];
                overflow = 1'b0;
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
                r = b << a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            SRL: begin
                r = b >> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            SRA: begin
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
                r = {b[15:0], 16'b0};
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
            default: begin
                r = 32'b0;  // avoid high impedance, prevent latch
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
        endcase
    end

    assign zero = (r == 32'b0);
    assign negative = r[31];

endmodule