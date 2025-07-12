module alu (
    input  [31:0] a,
    input  [31:0] b,
    input  [5:0]  aluc,
    output [31:0] r,
    output       zero,
    output       carry,
    output       negative,
    output       overflow,
    output       flag
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

    reg [31:0] res;
    reg         flag_temp;

    always @(*)
    begin
        case (aluc)
            ADD:   res = a + b;
            ADDU:  res = {32{1'b0}} + a + b;
            SUB:   res = a - b;
            SUBU:  res = {32{1'b0}} + a - b;
            AND:   res = a & b;
            OR:    res = a | b;
            XOR:   res = a ^ b;
            NOR:   res = ~(a | b);
            SLT:   res = (signed'(a) < signed'(b)) ? 32'd1 : 32'd0;
            SLTU:  res = (unsigned'(a) < unsigned'(b)) ? 32'd1 : 32'd0;
            SLL:   res = a << b[4:0];
            SRL:   res = a >> b[4:0];
            SRA:   res = signed'(a) >>> b[4:0];
            SLLV:  res = a << a[4:0];
            SRLV:  res = a >> a[4:0];
            SRAV:  res = signed'(a) >>> a[4:0];
            LUI:   res = {b[15:0], 16'd0};
            default: res = 32'bz;
        endcase

        zero = (res == 32'd0);
        carry = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) && ((a + b)[31] != res[31]);
        negative = (res[31] == 1'b1);
        overflow = (aluc == ADD || aluc == SUB) && ((signed'(a) > 0 && signed'(b) > 0 && signed'(res) < 0) || (signed'(a) < 0 && signed'(b) < 0 && signed'(res) > 0));
        flag_temp = (aluc == SLT || aluc == SLTU) ? res[0] : 1'bz;

    end

    assign r = res;
    assign flag = flag_temp;

endmodule