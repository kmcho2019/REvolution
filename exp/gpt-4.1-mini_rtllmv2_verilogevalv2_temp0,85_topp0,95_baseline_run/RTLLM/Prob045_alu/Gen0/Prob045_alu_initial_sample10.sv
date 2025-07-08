module alu(
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

// Operation codes
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

// Internal signals for signed operations
wire signed [31:0] a_signed = a;
wire signed [31:0] b_signed = b;

// Temp variables for carry and overflow detection
reg [32:0] addu_res;
reg [32:0] addu_res_sub;
reg [31:0] shift_amount;

always @(*) begin
    // Default assignments
    r = 32'bz;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'bz;

    case (aluc)
        ADD: begin
            // signed addition
            {carry, r} = {1'b0, a} + {1'b0, b};
            // overflow detection for signed addition:
            // overflow if signs of a and b are same but sign of result differs
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            flag = 1'bz;
        end

        ADDU: begin
            // unsigned addition, carry from MSB
            addu_res = {1'b0, a} + {1'b0, b};
            r = addu_res[31:0];
            carry = addu_res[32];
            overflow = 1'b0;
            flag = 1'bz;
        end

        SUB: begin
            // signed subtraction: a - b
            {carry, r} = {1'b0, a} - {1'b0, b};
            // overflow if signs of a and b differ, and sign of result differs from sign of a
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            // For carry in subtraction, it's borrow, so invert carry bit:
            // carry = 1 if no borrow, 0 if borrow occurred, so output carry as borrow indicator
            carry = ~carry;
            flag = 1'bz;
        end

        SUBU: begin
            // unsigned subtraction, detect borrow
            addu_res_sub = {1'b0, a} - {1'b0, b};
            r = addu_res_sub[31:0];
            // borrow if result MSB borrow bit is 1 (carry = 0 means borrow)
            carry = ~addu_res_sub[32]; // 1 if no borrow, 0 if borrow
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
            // set less than (signed)
            flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
        end

        SLTU: begin
            // set less than unsigned
            flag = (a < b) ? 1'b1 : 1'b0;
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
        end

        SLL: begin
            // logical shift left by b[4:0] (MIPS convention: shift amount in instruction)
            shift_amount = b[4:0];
            r = a << shift_amount;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        SRL: begin
            // logical shift right by b[4:0]
            shift_amount = b[4:0];
            r = a >> shift_amount;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        SRA: begin
            // arithmetic shift right by b[4:0]
            shift_amount = b[4:0];
            r = $signed(a) >>> shift_amount;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        SLLV: begin
            // logical shift left by a[4:0]
            shift_amount = a[4:0];
            r = b << shift_amount;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        SRLV: begin
            // logical shift right by a[4:0]
            shift_amount = a[4:0];
            r = b >> shift_amount;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        SRAV: begin
            // arithmetic shift right by a[4:0]
            shift_amount = a[4:0];
            r = $signed(b) >>> shift_amount;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        LUI: begin
            // Load upper immediate: (b << 16), ignoring 'a' per MIPS convention
            r = {b[15:0],16'b0};
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end

        default: begin
            // If undefined aluc, output high impedance
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