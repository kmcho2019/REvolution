module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output reg         negative,
    output reg         overflow,
    output wire        flag
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

// --- Arithmetic unit ---
wire [32:0] add_result;
wire [32:0] sub_result;
reg  [31:0] arithmetic_out;
reg         arithmetic_carry;
reg         arithmetic_overflow;

assign add_result = {1'b0, a} + {1'b0, b};
assign sub_result = {1'b0, a} - {1'b0, b};

always @(*) begin
    arithmetic_out = 32'b0;
    arithmetic_carry = 1'b0;
    arithmetic_overflow = 1'b0;

    case(aluc)
        ADD: begin
            arithmetic_out = add_result[31:0];
            arithmetic_carry = add_result[32];
            // Overflow detection for signed addition
            arithmetic_overflow = (~a[31] & ~b[31] & arithmetic_out[31]) | (a[31] & b[31] & ~arithmetic_out[31]);
        end
        ADDU: begin
            arithmetic_out = add_result[31:0];
            arithmetic_carry = add_result[32];
            arithmetic_overflow = 1'b0;
        end
        SUB: begin
            arithmetic_out = sub_result[31:0];
            arithmetic_carry = sub_result[32];
            // Overflow detection for signed subtraction
            arithmetic_overflow = (a[31] & ~b[31] & ~arithmetic_out[31]) | (~a[31] & b[31] & arithmetic_out[31]);
        end
        SUBU: begin
            arithmetic_out = sub_result[31:0];
            arithmetic_carry = sub_result[32];
            arithmetic_overflow = 1'b0;
        end
        default: begin
            arithmetic_out = 32'b0;
            arithmetic_carry = 1'b0;
            arithmetic_overflow = 1'b0;
        end
    endcase
end

// --- Logic unit ---
reg [31:0] logic_out;
always @(*) begin
    case(aluc)
        AND:  logic_out = a & b;
        OR:   logic_out = a | b;
        XOR:  logic_out = a ^ b;
        NOR:  logic_out = ~(a | b);
        LUI:  logic_out = {b[15:0],16'b0}; // Corrected: LUI takes immediate from b as per MIPS ISA
        default: logic_out = 32'b0;
    endcase
end

// --- Shift unit ---
reg [31:0] shift_in;
reg [4:0]  shamt;
reg [31:0] shift_out;
always @(*) begin
    shift_in = b;
    case (aluc)
        SLL:  shamt = a[4:0];
        SRL:  shamt = a[4:0];
        SRA:  shamt = a[4:0];
        SLLV: shamt = a[4:0];
        SRLV: shamt = a[4:0];
        SRAV: shamt = a[4:0];
        default: shamt = 5'd0;
    endcase

    case(aluc)
        SLL, SLLV: shift_out = shift_in << shamt;
        SRL, SRLV: shift_out = shift_in >> shamt;
        SRA, SRAV: shift_out = $signed(shift_in) >>> shamt;
        default: shift_out = 32'b0;
    endcase
end

// --- Main result multiplexer ---
always @(*) begin
    case (aluc)
        ADD, ADDU, SUB, SUBU: begin
            r = arithmetic_out;
            carry = arithmetic_carry;
            overflow = arithmetic_overflow;
        end
        AND, OR, XOR, NOR, LUI: begin
            r = logic_out;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLL, SRL, SRA, SLLV, SRLV, SRAV: begin
            r = shift_out;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLT: begin
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLTU: begin
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
        end
        default: begin
            r = 32'bz;        // High impedance on undefined ops
            carry = 1'bz;
            overflow = 1'bz;
        end
    endcase

    negative = r[31];
end

// --- Flag signal ---
assign flag = (aluc == SLT)  ? (($signed(a) < $signed(b)) ? 1'b1 : 1'b0) :
              (aluc == SLTU) ? ((a < b) ? 1'b1 : 1'b0) : 1'bz;

// --- Zero detection ---
assign zero = (r === 32'b0) ? 1'b1 : 1'b0;

endmodule