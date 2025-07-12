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

// Opcode parameter declarations
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

// Helper function for signed addition with carry and overflow detection
function [33:0] add32;
    input [31:0] x, y;
    begin
        add32 = {1'b0, x} + {1'b0, y};
    end
endfunction

// Helper function for signed subtraction with carry and overflow detection
function [33:0] sub32;
    input [31:0] x, y;
    begin
        sub32 = {1'b0, x} - {1'b0, y};
    end
endfunction

// Shift amount wires
wire [4:0] shamt_imm = a[4:0];    // For immediate shift opcodes
wire [4:0] shamt_var = a[4:0];    // For variable shift opcodes

// Internal variables for arithmetic results
reg [33:0] add_res;
reg [33:0] sub_res;

always @(*) begin
    // Default outputs are high impedance to detect invalid opcodes
    r        = 32'bz;
    carry    = 1'bz;
    negative = 1'bz;
    overflow = 1'bz;
    flag     = 1'bz;

    // Default arithmetic intermediates
    add_res = 34'd0;
    sub_res = 34'd0;

    case(aluc)
        // Addition with signed overflow and carry
        ADD: begin
            add_res = add32(a, b);
            r = add_res[31:0];
            carry = add_res[33]; // Carry out bit (bit 33)
            // Overflow detection for signed add:
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            negative = r[31];
            flag = 1'bz;
        end

        // Unsigned addition, carry valid, no overflow
        ADDU: begin
            add_res = add32(a, b);
            r = add_res[31:0];
            carry = add_res[33];
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end

        // Subtraction with signed overflow and carry (borrow)
        SUB: begin
            sub_res = sub32(a, b);
            r = sub_res[31:0];
            // carry = borrow: no borrow if a >= b
            // carry out bit indicates borrow in subtraction (carry out = NOT borrow)
            carry = sub_res[33]; // MSB of subtraction result
            // Overflow detection for signed subtraction
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            negative = r[31];
            flag = 1'bz;
        end

        // Unsigned subtraction, carry valid, no overflow
        SUBU: begin
            sub_res = sub32(a, b);
            r = sub_res[31:0];
            carry = sub_res[33];
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end

        // Bitwise AND
        AND: begin
            r = a & b;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end

        // Bitwise OR
        OR: begin
            r = a | b;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end

        // Bitwise XOR
        XOR: begin
            r = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end

        // Bitwise NOR
        NOR: begin
            r = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end

        // Set less than (signed)
        SLT: begin
            r = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
            flag = r[0];
        end

        // Set less than unsigned
        SLTU: begin
            r = (a < b) ? 32'd1 : 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
            flag = r[0];
        end

        // Shift left logical (immediate)
        SLL: begin
            r = b << shamt_imm;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end

        // Shift right logical (immediate)
        SRL: begin
            r = b >> shamt_imm;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end

        // Shift right arithmetic (immediate)
        SRA: begin
            r = $signed(b) >>> shamt_imm;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end

        // Shift left logical (variable)
        SLLV: begin
            r = b << shamt_var;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end

        // Shift right logical (variable)
        SRLV: begin
            r = b >> shamt_var;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end

        // Shift right arithmetic (variable)
        SRAV: begin
            r = $signed(b) >>> shamt_var;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end

        // Load upper immediate (LUI): shift b[15:0] by 16 bits left, fill lower bits with zero
        LUI: begin
            r = {b[15:0], 16'd0};
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end

        // Default invalid operation: all outputs high impedance
        default: begin
            r        = 32'bz;
            carry    = 1'bz;
            overflow = 1'bz;
            negative = 1'bz;
            flag     = 1'bz;
        end
    endcase
end

// zero flag: high if result is zero, else low
assign zero = (r === 32'd0);

endmodule