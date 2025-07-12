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

// Operation categories
parameter ARITHMETIC = 2'b00;
parameter LOGICAL = 2'b01;
parameter SHIFT = 2'b10;
parameter MISCELLANEOUS = 2'b11;

// Arithmetic operations
parameter ADD = 6'b100000;
parameter SUB = 6'b100010;
parameter ADDU = 6'b100001;
parameter SUBU = 6'b100011;

// Logical operations
parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;

// Shift operations
parameter SLL = 6'b000000;
parameter SRL = 6'b000010;
parameter SRA = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;

// Miscellaneous operations
parameter SLT = 6'b101010;
parameter SLTU = 6'b101011;
parameter LUI = 6'b001111;

// Category decoders
wire [1:0] category;
assign category = aluc[5:4];

// Output flags
reg [31:0] res;
always @(*) begin
    case (aluc)
        ADD: begin
            res = a + b;
            carry = (a[31] != b[31]) && (a[31] != res[31]);
            overflow = (a[31] != b[31]) && (a[31] != res[31]);
        end
        SUB: begin
            res = a - b;
            carry = (a[31] == b[31]) && (a[31] != res[31]);
            overflow = (a[31] == b[31]) && (a[31] != res[31]);
        end
        ADDU: begin
            res = a + b;
            carry = (a[31] != b[31]) && (a[31] != res[31]);
            overflow = 1'b0;
        end
        SUBU: begin
            res = a - b;
            carry = (a[31] == b[31]) && (a[31] != res[31]);
            overflow = 1'b0;
        end
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        SLL: res = a << b[4:0];
        SRL: res = a >> b[4:0];
        SRA: res = a >>> b[4:0];
        SLLV: res = a << b;
        SRLV: res = a >> b;
        SRAV: res = a >>> b;
        SLT: begin
            res = (signed'(a) < signed'(b)) ? 32'd1 : 32'd0;
            flag = (signed'(a) < signed'(b));
        end
        SLTU: begin
            res = (a < b) ? 32'd1 : 32'd0;
            flag = (a < b);
        end
        LUI: begin
            res = {a[15:0], 16'd0};
            flag = 1'b0;
        end
        default: begin
            res = 32'bx;
            carry = 1'bx;
            overflow = 1'bx;
            flag = 1'bx;
        end
    endcase
end

assign r = res;
assign zero = (res == 32'd0);
assign negative = (res[31] == 1'b1);

endmodule