module alu(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [5:0] aluc,
    output wire [31:0] r,
    output wire zero,
    output wire carry,
    output wire negative,
    output wire overflow,
    output wire flag
);

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

reg [31:0] r_reg;
reg zero_reg;
reg carry_reg;
reg negative_reg;
reg overflow_reg;
reg flag_reg;

always @(*) begin
    case (aluc)
        ADD: begin
            r_reg = a + b;
            zero_reg = (r_reg == 0);
            carry_reg = (a[31] == b[31] && a[31] != r_reg[31]);
            negative_reg = r_reg[31];
            overflow_reg = (a[31] == b[31] && a[31] != r_reg[31]);
            flag_reg = 0;
        end
        ADDU: begin
            r_reg = a + b;
            zero_reg = (r_reg == 0);
            carry_reg = (r_reg[31] == 1'b1);
            negative_reg = r_reg[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        SUB: begin
            r_reg = a - b;
            zero_reg = (r_reg == 0);
            carry_reg = (a[31] != b[31] && a[31] == r_reg[31]);
            negative_reg = r_reg[31];
            overflow_reg = (a[31] != b[31] && a[31] == r_reg[31]);
            flag_reg = 0;
        end
        SUBU: begin
            r_reg = a - b;
            zero_reg = (r_reg == 0);
            carry_reg = (r_reg[31] == 1'b0);
            negative_reg = r_reg[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        AND: begin
            r_reg = a & b;
            zero_reg = (r_reg == 0);
            carry_reg = 0;
            negative_reg = r_reg[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        OR: begin
            r_reg = a | b;
            zero_reg = (r_reg == 0);
            carry_reg = 0;
            negative_reg = r_reg[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        XOR: begin
            r_reg = a ^ b;
            zero_reg = (r_reg == 0);
            carry_reg = 0;
            negative_reg = r_reg[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        NOR: begin
            r_reg = ~(a | b);
            zero_reg = (r_reg == 0);
            carry_reg = 0;
            negative_reg = r_reg[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        SLT: begin
            r_reg = (signed'(a) < signed'(b)) ? 32'd1 : 32'd0;
            zero_reg = (r_reg == 0);
            carry_reg = 0;
            negative_reg = r_reg[31];
            overflow_reg = 0;
            flag_reg = (signed'(a) < signed'(b));
        end
        SLTU: begin
            r_reg = (a < b) ? 32'd1 : 32'd0;
            zero_reg = (r_reg == 0);
            carry_reg = 0;
            negative_reg = r_reg[31];
            overflow_reg = 0;
            flag_reg = (a < b);
        end
        SLL: begin
            if (b[4:0] <= 31) begin
                r_reg = a << b[4:0];
            end else begin
                r_reg = 32'd0;
            end
            zero_reg = (r_reg == 0);
            carry_reg = 0;
            negative_reg = r_reg[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        SRL: begin
            if (b[4:0] <= 31) begin
                r_reg = a >> b[4:0];
            end else begin
                r_reg = 32'd0;
            end
            zero_reg = (r_reg == 0);
            carry_reg = 0;
            negative_reg = r_reg[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        SRA: begin
            if (b[4:0] <= 31) begin
                r_reg = a >>> b[4:0];
            end else begin
                r_reg = 32'd0;
            end
            zero_reg = (r_reg == 0);
            carry_reg = 0;
            negative_reg = r_reg[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        LUI: begin
            r_reg = {b[15:0], 16'd0};
            zero_reg = (r_reg == 0);
            carry_reg = 0;
            negative_reg = r_reg[31];
            overflow_reg = 0;
            flag_reg = 0;
        end
        default: begin
            r_reg = 32'd0;
            zero_reg = 1;
            carry_reg = 0;
            negative_reg = 0;
            overflow_reg = 0;
            flag_reg = 0;
        end
    endcase
end

assign r = r_reg;
assign zero = zero_reg;
assign carry = carry_reg;
assign negative = negative_reg;
assign overflow = overflow_reg;
assign flag = flag_reg;

endmodule