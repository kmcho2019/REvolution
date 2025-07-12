module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0] aluc,
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

wire signed [31:0] sa;
wire signed [31:0] sb;

assign sa = a;
assign sb = b;

reg [31:0] res;
reg zero_reg;
reg carry_reg;
reg negative_reg;
reg overflow_reg;
reg flag_reg;

assign r = res;
assign zero = zero_reg;
assign carry = carry_reg;
assign negative = negative_reg;
assign overflow = overflow_reg;
assign flag = flag_reg;

always @(a or b or aluc) begin
    case (aluc)
        ADD: begin
            {carry_reg, res} = sa + sb;
            if (res == 0) begin
                zero_reg = 1'b1;
            end else begin
                zero_reg = 1'b0;
            end
            if (res[31] == 1'b1 && sa[31] == 1'b0 && sb[31] == 1'b0) begin
                overflow_reg = 1'b1;
            end else if (res[31] == 1'b0 && sa[31] == 1'b1 && sb[31] == 1'b1) begin
                overflow_reg = 1'b1;
            end else begin
                overflow_reg = 1'b0;
            end
            negative_reg = res[31];
            flag_reg = 1'bz;
        end
        ADDU: begin
            {carry_reg, res} = a + b;
            if (res == 0) begin
                zero_reg = 1'b1;
            end else begin
                zero_reg = 1'b0;
            end
            overflow_reg = 1'b0;
            negative_reg = res[31];
            flag_reg = 1'bz;
        end
        SUB: begin
            {carry_reg, res} = sa - sb;
            if (res == 0) begin
                zero_reg = 1'b1;
            end else begin
                zero_reg = 1'b0;
            end
            if (res[31] == 1'b1 && sa[31] == 1'b0 && sb[31] == 1'b1) begin
                overflow_reg = 1'b1;
            end else if (res[31] == 1'b0 && sa[31] == 1'b1 && sb[31] == 1'b0) begin
                overflow_reg = 1'b1;
            end else begin
                overflow_reg = 1'b0;
            end
            negative_reg = res[31];
            flag_reg = 1'bz;
        end
        SUBU: begin
            {carry_reg, res} = a - b;
            if (res == 0) begin
                zero_reg = 1'b1;
            end else begin
                zero_reg = 1'b0;
            end
            overflow_reg = 1'b0;
            negative_reg = res[31];
            flag_reg = 1'bz;
        end
        AND: begin
            res = a & b;
            if (res == 0) begin
                zero_reg = 1'b1;
            end else begin
                zero_reg = 1'b0;
            end
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
            flag_reg = 1'bz;
        end
        OR: begin
            res = a | b;
            if (res == 0) begin
                zero_reg = 1'b1;
            end else begin
                zero_reg = 1'b0;
            end
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
            flag_reg = 1'bz;
        end
        XOR: begin
            res = a ^ b;
            if (res == 0) begin
                zero_reg = 1'b1;
            end else begin
                zero_reg = 1'b0;
            end
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
            flag_reg = 1'bz;
        end
        NOR: begin
            res = ~(a | b);
            if (res == 0) begin
                zero_reg = 1'b1;
            end else begin
                zero_reg = 1'b0;
            end
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
            flag_reg = 1'bz;
        end
        SLT: begin
            if (sa < sb) begin
                res = 32'b1;
            end else begin
                res = 32'b0;
            end
            zero_reg = ~res[0];
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
            flag_reg = res[0];
        end
        SLTU: begin
            if (a < b) begin
                res = 32'b1;
            end else begin
                res = 32'b0;
            end
            zero_reg = ~res[0];
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
            flag_reg = res[0];
        end
        SLL: begin
            res = a << a[4:0];
            if (res == 0) begin
                zero_reg = 1'b1;
            end else begin
                zero_reg = 1'b0;
            end
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
            flag_reg = 1'bz;
        end
        SRL: begin
            res = a >> a[4:0];
            if (res == 0) begin
                zero_reg = 1'b1;
            end else begin
                zero_reg = 1'b0;
            end
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
            flag_reg = 1'bz;
        end
        SRA: begin
            res = sa >>> a[4:0];
            if (res == 0) begin
                zero_reg = 1'b1;
            end else begin
                zero_reg = 1'b0;
            end
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
            flag_reg = 1'bz;
        end
        SLLV: begin
            res = a << b[4:0];
            if (res == 0) begin
                zero_reg = 1'b1;
            end else begin
                zero_reg = 1'b0;
            end
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
            flag_reg = 1'bz;
        end
        SRLV: begin
            res = a >> b[4:0];
            if (res == 0) begin
                zero_reg = 1'b1;
            end else begin
                zero_reg = 1'b0;
            end
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
            flag_reg = 1'bz;
        end
        SRAV: begin
            res = sa >>> b[4:0];
            if (res == 0) begin
                zero_reg = 1'b1;
            end else begin
                zero_reg = 1'b0;
            end
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
            flag_reg = 1'bz;
        end
        LUI: begin
            res = {a[15:0], 16'b0};
            if (res == 0) begin
                zero_reg = 1'b1;
            end else begin
                zero_reg = 1'b0;
            end
            carry_reg = 1'b0;
            overflow_reg = 1'b0;
            negative_reg = res[31];
            flag_reg = 1'bz;
        end
        default: begin
            res = 32'bz;
            zero_reg = 1'bz;
            carry_reg = 1'bz;
            overflow_reg = 1'bz;
            negative_reg = 1'bz;
            flag_reg = 1'bz;
        end
    endcase
end

endmodule