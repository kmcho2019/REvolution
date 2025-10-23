module alu(
    input [31:0] a, 
    input [31:0] b, 
    input [5:0] aluc, 
    output [31:0] r, 
    output zero, 
    output carry, 
    output negative, 
    output overflow, 
    output flag
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

    wire [31:0] signed_a;
    wire [31:0] signed_b;
    reg [31:0] res;

    assign signed_a = $signed(a);
    assign signed_b = $signed(b);

    assign r = res;

    always @(a or b or aluc) begin
        case(aluc)
            ADD: begin
                res = signed_a + signed_b;
                if (res == 32'd0) assign zero = 1'b1;
                else assign zero = 1'b0;
                assign carry = 1'b0;
                assign negative = (res[31] == 1'b1)? 1'b1 : 1'b0;
                assign overflow = ((signed_a[31] == 1'b1 && signed_b[31] == 1'b1 && res[31] == 1'b0) || (signed_a[31] == 1'b0 && signed_b[31] == 1'b0 && res[31] == 1'b1))? 1'b1 : 1'b0;
                assign flag = 1'bz;
            end
            ADDU: begin
                res = a + b;
                if (res == 32'd0) assign zero = 1'b1;
                else assign zero = 1'b0;
                assign carry = (a[31] == 1'b1 && b[31] == 1'b1 && res[31] == 1'b0)? 1'b1 : 1'b0;
                assign negative = (res[31] == 1'b1)? 1'b1 : 1'b0;
                assign overflow = 1'b0;
                assign flag = 1'bz;
            end
            SUB: begin
                res = signed_a - signed_b;
                if (res == 32'd0) assign zero = 1'b1;
                else assign zero = 1'b0;
                assign carry = 1'b0;
                assign negative = (res[31] == 1'b1)? 1'b1 : 1'b0;
                assign overflow = ((signed_a[31] == 1'b1 && signed_b[31] == 1'b0 && res[31] == 1'b0) || (signed_a[31] == 1'b0 && signed_b[31] == 1'b1 && res[31] == 1'b1))? 1'b1 : 1'b0;
                assign flag = 1'bz;
            end
            SUBU: begin
                res = a - b;
                if (res == 32'd0) assign zero = 1'b1;
                else assign zero = 1'b0;
                assign carry = (a[31] == 1'b1 && b[31] == 1'b0 && res[31] == 1'b0)? 1'b1 : 1'b0;
                assign negative = (res[31] == 1'b1)? 1'b1 : 1'b0;
                assign overflow = 1'b0;
                assign flag = 1'bz;
            end
            AND: begin
                res = a & b;
                if (res == 32'd0) assign zero = 1'b1;
                else assign zero = 1'b0;
                assign carry = 1'b0;
                assign negative = (res[31] == 1'b1)? 1'b1 : 1'b0;
                assign overflow = 1'b0;
                assign flag = 1'bz;
            end
            OR: begin
                res = a | b;
                if (res == 32'd0) assign zero = 1'b1;
                else assign zero = 1'b0;
                assign carry = 1'b0;
                assign negative = (res[31] == 1'b1)? 1'b1 : 1'b0;
                assign overflow = 1'b0;
                assign flag = 1'bz;
            end
            XOR: begin
                res = a ^ b;
                if (res == 32'd0) assign zero = 1'b1;
                else assign zero = 1'b0;
                assign carry = 1'b0;
                assign negative = (res[31] == 1'b1)? 1'b1 : 1'b0;
                assign overflow = 1'b0;
                assign flag = 1'bz;
            end
            NOR: begin
                res = ~(a | b);
                if (res == 32'd0) assign zero = 1'b1;
                else assign zero = 1'b0;
                assign carry = 1'b0;
                assign negative = (res[31] == 1'b1)? 1'b1 : 1'b0;
                assign overflow = 1'b0;
                assign flag = 1'bz;
            end
            SLT: begin
                res = (signed_a < signed_b)? 32'd1 : 32'd0;
                if (res == 32'd0) assign zero = 1'b1;
                else assign zero = 1'b0;
                assign carry = 1'b0;
                assign negative = (res[31] == 1'b1)? 1'b1 : 1'b0;
                assign overflow = 1'b0;
                assign flag = (signed_a < signed_b)? 1'b1 : 1'b0;
            end
            SLTU: begin
                res = (a < b)? 32'd1 : 32'd0;
                if (res == 32'd0) assign zero = 1'b1;
                else assign zero = 1'b0;
                assign carry = 1'b0;
                assign negative = (res[31] == 1'b1)? 1'b1 : 1'b0;
                assign overflow = 1'b0;
                assign flag = (a < b)? 1'b1 : 1'b0;
            end
            SLL: begin
                res = a << 5'b0;
                if (res == 32'd0) assign zero = 1'b1;
                else assign zero = 1'b0;
                assign carry = 1'b0;
                assign negative = (res[31] == 1'b1)? 1'b1 : 1'b0;
                assign overflow = 1'b0;
                assign flag = 1'bz;
            end
            SRL: begin
                res = a >> 5'b0;
                if (res == 32'd0) assign zero = 1'b1;
                else assign zero = 1'b0;
                assign carry = 1'b0;
                assign negative = (res[31] == 1'b1)? 1'b1 : 1'b0;
                assign overflow = 1'b0;
                assign flag = 1'bz;
            end
            SRA: begin
                res = { {16{a[31]}}, a } >> 5'b0;
                if (res == 32'd0) assign zero = 1'b1;
                else assign zero = 1'b0;
                assign carry = 1'b0;
                assign negative = (res[31] == 1'b1)? 1'b1 : 1'b0;
                assign overflow = 1'b0;
                assign flag = 1'bz;
            end
            SLLV: begin
                res = a << b[4:0];
                if (res == 32'd0) assign zero = 1'b1;
                else assign zero = 1'b0;
                assign carry = 1'b0;
                assign negative = (res[31] == 1'b1)? 1'b1 : 1'b0;
                assign overflow = 1'b0;
                assign flag = 1'bz;
            end
            SRLV: begin
                res = a >> b[4:0];
                if (res == 32'd0) assign zero = 1'b1;
                else assign zero = 1'b0;
                assign carry = 1'b0;
                assign negative = (res[31] == 1'b1)? 1'b1 : 1'b0;
                assign overflow = 1'b0;
                assign flag = 1'bz;
            end
            SRAV: begin
                res = { {16{a[31]}}, a } >> b[4:0];
                if (res == 32'd0) assign zero = 1'b1;
                else assign zero = 1'b0;
                assign carry = 1'b0;
                assign negative = (res[31] == 1'b1)? 1'b1 : 1'b0;
                assign overflow = 1'b0;
                assign flag = 1'bz;
            end
            LUI: begin
                res = { a[15:0], 16'b0 };
                if (res == 32'd0) assign zero = 1'b1;
                else assign zero = 1'b0;
                assign carry = 1'b0;
                assign negative = (res[31] == 1'b1)? 1'b1 : 1'b0;
                assign overflow = 1'b0;
                assign flag = 1'bz;
            end
            default: begin
                res = 32'bz;
                assign zero = 1'bz;
                assign carry = 1'bz;
                assign negative = 1'bz;
                assign overflow = 1'bz;
                assign flag = 1'bz;
            end
        endcase
    end

endmodule