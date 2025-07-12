module alu (
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output [31:0] r,
    output        zero,
    output        carry,
    output        negative,
    output        overflow,
    output        flag
);

// Operation categories
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
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI = 6'b001111;

// Internal signals
reg [31:0] res;
reg        zero_int;
reg        carry_int;
reg        negative_int;
reg        overflow_int;
reg        flag_int;

// Operation selection stage
always @(*) begin
    case (aluc)
        ADD: begin
            res = a + b;
            carry_int = (a[31]!= b[31]) && (a[31]!= res[31]);
            overflow_int = (a[31] == b[31]) && (a[31]!= res[31]);
            flag_int = 1'b0;
        end
        ADDU: begin
            res = a + b;
            carry_int = (res[31] == 1'b1) && (a[31]!= res[31]);
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end
        SUB: begin
            res = a - b;
            carry_int = (a[31] == b[31]) && (a[31]!= res[31]);
            overflow_int = (a[31]!= b[31]) && (a[31] == res[31]);
            flag_int = 1'b0;
        end
        SUBU: begin
            res = a - b;
            carry_int = (res[31] == 1'b0) && (a[31]!= res[31]);
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end
        AND: begin
            res = a & b;
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end
        OR: begin
            res = a | b;
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end
        XOR: begin
            res = a ^ b;
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end
        NOR: begin
            res = ~(a | b);
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end
        SLL: begin
            res = a << (b[4:0]);
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end
        SRL: begin
            res = a >> (b[4:0]);
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end
        SRA: begin
            res = a >>> (b[4:0]);
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end
        SLLV: begin
            res = a << b;
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end
        SRLV: begin
            res = a >> b;
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end
        SRAV: begin
            res = a >>> b;
            carry_int = 1'b0;
            overflow_int = 1'b0;
            flag_int = 1'b0;
        end
        SLT: begin
            res = (signed'(a) < signed'(b))? 32'd1 : 32'd0;
            flag_int = (signed'(a) < signed'(b));
            carry_int = 1'b0;
            overflow_int = 1'b0;
        end
        SLTU: begin
            res = (a < b)? 32'd1 : 32'd0;
            flag_int = (a < b);
            carry_int = 1'b0;
            overflow_int = 1'b0;
        end
        LUI: begin
            res = {b[15:0], 16'd0};
            flag_int = 1'b0;
            carry_int = 1'b0;
            overflow_int = 1'b0;
        end
        default: begin
            res = 32'bx;
            carry_int = 1'bx;
            overflow_int = 1'bx;
            flag_int = 1'bx;
        end
    endcase
    zero_int = (res == 32'd0);
    negative_int = (res[31] == 1'b1);
end

// Execution stage
always @(*) begin
    r = res;
    zero = zero_int;
    carry = carry_int;
    negative = negative_int;
    overflow = overflow_int;
    flag = flag_int;
end

endmodule