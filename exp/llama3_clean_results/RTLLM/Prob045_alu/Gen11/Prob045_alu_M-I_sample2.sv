module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);

// Define operation codes
parameter ADD = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB = 6'b100010;
parameter SUBU = 6'b100011;
parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;
parameter SLT = 6'b101010;
parameter SLTU = 6'b101011;
parameter SLL = 6'b000000;
parameter SRL = 6'b000010;
parameter SRA = 6'b000011;
parameter LUI = 6'b001111;

// Internal signals
wire [31:0] add_result;
wire [31:0] sub_result;
wire [31:0] shift_result;

// Shared adder for ADD and SUB
assign add_result = a + b;
assign sub_result = a - b;

// Shift operations
always @(*) begin
    case (aluc)
        SLL: shift_result = a << b[4:0];
        SRL: shift_result = a >> b[4:0];
        SRA: shift_result = a >>> b[4:0];
        default: shift_result = 32'bx;
    endcase
end

// Logic operations
assign r = (aluc == AND) ? (a & b) :
           (aluc == OR) ? (a | b) :
           (aluc == XOR) ? (a ^ b) :
           (aluc == NOR) ? ~(a | b) :
           (aluc == LUI) ? {16'b0, a[15:0]} :
           add_result;

// Flag calculations
always @(*) begin
    case (aluc)
        ADD, ADDU: begin
            zero = (add_result == 32'd0);
            carry = ((add_result[31] == 1'b1) && (aluc == ADD || aluc == ADDU));
            negative = (add_result[31] == 1'b1);
            overflow = ((aluc == ADD) && (a[31] != b[31]) && (a[31] != add_result[31])) ? 1'b1 : 1'b0;
            flag = 1'b0;
        end
        SUB, SUBU: begin
            zero = (sub_result == 32'd0);
            carry = ((sub_result[31] == 1'b1) && (aluc == SUB || aluc == SUBU));
            negative = (sub_result[31] == 1'b1);
            overflow = ((aluc == SUB) && (a[31] != b[31]) && (a[31] != sub_result[31])) ? 1'b1 : 1'b0;
            flag = 1'b0;
        end
        SLT: begin
            r = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            zero = (r == 32'd0);
            carry = 1'b0;
            negative = (r[31] == 1'b1);
            overflow = 1'b0;
            flag = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0;
        end
        SLTU: begin
            r = (a < b) ? 32'd1 : 32'd0;
            zero = (r == 32'd0);
            carry = 1'b0;
            negative = (r[31] == 1'b1);
            overflow = 1'b0;
            flag = (a < b) ? 1'b1 : 1'b0;
        end
        default: begin
            r = 32'bx;
            zero = 1'bx;
            carry = 1'bx;
            negative = 1'bx;
            overflow = 1'bx;
            flag = 1'bx;
        end
    endcase
end

endmodule