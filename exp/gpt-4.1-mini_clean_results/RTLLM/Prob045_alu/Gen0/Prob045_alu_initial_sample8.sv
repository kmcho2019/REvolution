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

    wire [31:0] b_shifted; // for shift amount extraction

    // Signed versions of inputs
    wire signed [31:0] a_s = a;
    wire signed [31:0] b_s = b;

    // Temporary registers and wires for arithmetic operations
    reg [32:0] add_result; // 33-bit for carry detection
    reg [32:0] sub_result; // 33-bit for borrow detection

    always @(*) begin
        // Defaults
        r = 32'b0;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'bz; // high impedance by default

        case(aluc)
            ADD: begin
                add_result = {1'b0, a} + {1'b0, b};
                r = add_result[31:0];
                carry = add_result[32];
                // Overflow: occurs if sign of a == sign of b and sign of result != sign of a
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
                flag = 1'bz;
            end
            ADDU: begin
                add_result = {1'b0, a} + {1'b0, b};
                r = add_result[31:0];
                carry = add_result[32];
                overflow = 1'b0; // unsigned add no overflow
                flag = 1'bz;
            end
            SUB: begin
                sub_result = {1'b0, a} - {1'b0, b};
                r = sub_result[31:0];
                carry = ~sub_result[32]; // borrow = ~carry in subtraction
                // Overflow: if sign of a != sign of b and sign of result != sign of a
                overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
                flag = 1'bz;
            end
            SUBU: begin
                sub_result = {1'b0, a} - {1'b0, b};
                r = sub_result[31:0];
                carry = ~sub_result[32]; // borrow = ~carry
                overflow = 1'b0;
                flag = 1'bz;
            end
            AND: begin
                r = a & b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            OR: begin
                r = a | b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            XOR: begin
                r = a ^ b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            NOR: begin
                r = ~(a | b);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
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
                // Shift b by a[4:0] bits left logical
                r = b << a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRL: begin
                // Shift b by a[4:0] bits right logical
                r = b >> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRA: begin
                // Shift b by a[4:0] bits right arithmetic
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SLLV: begin
                // Shift b by a[4:0] bits left logical (variable shift)
                r = b << a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRLV: begin
                // Shift b by a[4:0] bits right logical (variable shift)
                r = b >> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRAV: begin
                // Shift b by a[4:0] bits right arithmetic (variable shift)
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            LUI: begin
                // Load upper immediate: upper 16 bits are b[15:0], lower 16 zero
                r = {b[15:0], 16'b0};
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            default: begin
                r = 32'bz;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
        endcase
    end

    assign zero = (r == 32'b0) ? 1'b1 : 1'b0;
    assign negative = r[31];

endmodule