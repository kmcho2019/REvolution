module alu(
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

// Internal signals for arithmetic
reg [32:0] add_sub_result;
reg        add_sub_carry;
reg        add_sub_overflow;
reg [31:0] arithmetic_result;

// Internal signals for shifts
wire [4:0] shamt = ( (aluc == SLL) | (aluc == SRL) | (aluc == SRA) ) ? a[4:0] : a[4:0];
wire [31:0] shift_input = b;
reg  [31:0] shift_result;

// Internal signals for logical operations
reg [31:0] logic_result;

// Compute add/sub operations
always @(*) begin
    case (aluc)
        ADD:  add_sub_result = {1'b0, a} + {1'b0, b};
        ADDU: add_sub_result = {1'b0, a} + {1'b0, b};
        SUB:  add_sub_result = {1'b0, a} - {1'b0, b};
        SUBU: add_sub_result = {1'b0, a} - {1'b0, b};
        default: add_sub_result = 33'd0;
    endcase

    add_sub_carry = add_sub_result[32];

    // Overflow detection for signed add/sub
    if (aluc == ADD) begin
        // overflow if signs of a and b same but differ from result
        add_sub_overflow = (~a[31] & ~b[31] & add_sub_result[31]) | (a[31] & b[31] & ~add_sub_result[31]);
    end else if (aluc == SUB) begin
        // overflow if signs of a and b different and result sign differs from a
        add_sub_overflow = (a[31] & ~b[31] & ~add_sub_result[31]) | (~a[31] & b[31] & add_sub_result[31]);
    end else begin
        add_sub_overflow = 1'b0;
    end

    arithmetic_result = add_sub_result[31:0];
end

// Compute logical operations
always @(*) begin
    case (aluc)
        AND: logic_result = a & b;
        OR:  logic_result = a | b;
        XOR: logic_result = a ^ b;
        NOR: logic_result = ~(a | b);
        default: logic_result = 32'd0;
    endcase
end

// Compute shift operations
always @(*) begin
    case (aluc)
        SLL:  shift_result = b << a[4:0];
        SRL:  shift_result = b >> a[4:0];
        SRA:  shift_result = $signed(b) >>> a[4:0];
        SLLV: shift_result = b << a[4:0];
        SRLV: shift_result = b >> a[4:0];
        SRAV: shift_result = $signed(b) >>> a[4:0];
        default: shift_result = 32'd0;
    endcase
end

// Result multiplexer
always @(*) begin
    r = 32'd0;
    carry = 1'b0;
    overflow = 1'b0;
    negative = 1'b0;

    case (aluc)
        ADD, ADDU, SUB, SUBU: begin
            r = arithmetic_result;
            carry = add_sub_carry;
            overflow = add_sub_overflow;
        end
        AND, OR, XOR, NOR: begin
            r = logic_result;
        end
        SLL, SRL, SRA, SLLV, SRLV, SRAV: begin
            r = shift_result;
        end
        SLT: begin
            r = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
        end
        SLTU: begin
            r = (a < b) ? 32'd1 : 32'd0;
        end
        LUI: begin
            // LUI loads immediate (b) shifted left 16 bits into r
            r = b << 16;
        end
        default: begin
            r = 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
        end
    endcase

    negative = r[31];
end

assign zero = (r == 32'd0);

// Assign flag only for SLT and SLTU, else high impedance (tri-state)
assign flag = (aluc == SLT || aluc == SLTU) ? r[0] : 1'bz;

endmodule