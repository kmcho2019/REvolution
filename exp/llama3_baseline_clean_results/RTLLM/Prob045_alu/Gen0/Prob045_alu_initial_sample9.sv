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

    reg [31:0] res;
    wire [31:0] signed_a, signed_b;

    assign signed_a = a;
    assign signed_b = b;

    always @(a, b, aluc) begin
        case (aluc)
            ADD: begin
                {carry, res} = signed_a + signed_b;
                if (res == 32'd0) begin
                    zero = 1'b1;
                end else begin
                    zero = 1'b0;
                end
                if ((signed_a[31] == 1'b0) && (signed_b[31] == 1'b0) && (res[31] == 1'b1)) begin
                    overflow = 1'b1;
                end else if ((signed_a[31] == 1'b1) && (signed_b[31] == 1'b1) && (res[31] == 1'b0)) begin
                    overflow = 1'b1;
                end else begin
                    overflow = 1'b0;
                end
                negative = res[31];
            end

            ADDU: begin
                {carry, res} = a + b;
                if (res == 32'd0) begin
                    zero = 1'b1;
                end else begin
                    zero = 1'b0;
                end
                overflow = 1'b0;
                negative = 1'b0;
            end

            SUB: begin
                {carry, res} = signed_a - signed_b;
                if (res == 32'd0) begin
                    zero = 1'b1;
                end else begin
                    zero = 1'b0;
                end
                if ((signed_a[31] == 1'b0) && (signed_b[31] == 1'b1) && (res[31] == 1'b1)) begin
                    overflow = 1'b1;
                end else if ((signed_a[31] == 1'b1) && (signed_b[31] == 1'b0) && (res[31] == 1'b0)) begin
                    overflow = 1'b1;
                end else begin
                    overflow = 1'b0;
                end
                negative = res[31];
            end

            SUBU: begin
                {carry, res} = a - b;
                if (res == 32'd0) begin
                    zero = 1'b1;
                end else begin
                    zero = 1'b0;
                end
                overflow = 1'b0;
                negative = 1'b0;
            end

            AND: begin
                res = a & b;
                if (res == 32'd0) begin
                    zero = 1'b1;
                end else begin
                    zero = 1'b0;
                end
                carry = 1'b0;
                overflow = 1'b0;
                negative = res[31];
            end

            OR: begin
                res = a | b;
                if (res == 32'd0) begin
                    zero = 1'b1;
                end else begin
                    zero = 1'b0;
                end
                carry = 1'b0;
                overflow = 1'b0;
                negative = res[31];
            end

            XOR: begin
                res = a ^ b;
                if (res == 32'd0) begin
                    zero = 1'b1;
                end else begin
                    zero = 1'b0;
                end
                carry = 1'b0;
                overflow = 1'b0;
                negative = res[31];
            end

            NOR: begin
                res = ~(a | b);
                if (res == 32'd0) begin
                    zero = 1'b1;
                end else begin
                    zero = 1'b0;
                end
                carry = 1'b0;
                overflow = 1'b0;
                negative = res[31];
            end

            SLT: begin
                if (signed_a < signed_b) begin
                    res = 32'd1;
                end else begin
                    res = 32'd0;
                end
                if (res == 32'd0) begin
                    zero = 1'b1;
                end else begin
                    zero = 1'b0;
                end
                carry = 1'b0;
                overflow = 1'b0;
                negative = res[31];
                flag = 1'b1;
            end

            SLTU: begin
                if (a < b) begin
                    res = 32'd1;
                end else begin
                    res = 32'd0;
                end
                if (res == 32'd0) begin
                    zero = 1'b1;
                end else begin
                    zero = 1'b0;
                end
                carry = 1'b0;
                overflow = 1'b0;
                negative = res[31];
                flag = 1'b1;
            end

            SLL: begin
                res = a << 5'b0;
                if (res == 32'd0) begin
                    zero = 1'b1;
                end else begin
                    zero = 1'b0;
                end
                carry = 1'b0;
                overflow = 1'b0;
                negative = res[31];
            end

            SRL: begin
                res = a >> 5'b0;
                if (res == 32'd0) begin
                    zero = 1'b1;
                end else begin
                    zero = 1'b0;
                end
                carry = 1'b0;
                overflow = 1'b0;
                negative = res[31];
            end

            SRA: begin
                res = signed_a >>> 5'b0;
                if (res == 32'd0) begin
                    zero = 1'b1;
                end else begin
                    zero = 1'b0;
                end
                carry = 1'b0;
                overflow = 1'b0;
                negative = res[31];
            end

            SLLV: begin
                res = a << b[4:0];
                if (res == 32'd0) begin
                    zero = 1'b1;
                end else begin
                    zero = 1'b0;
                end
                carry = 1'b0;
                overflow = 1'b0;
                negative = res[31];
            end

            SRLV: begin
                res = a >> b[4:0];
                if (res == 32'd0) begin
                    zero = 1'b1;
                end else begin
                    zero = 1'b0;
                end
                carry = 1'b0;
                overflow = 1'b0;
                negative = res[31];
            end

            SRAV: begin
                res = signed_a >>> b[4:0];
                if (res == 32'd0) begin
                    zero = 1'b1;
                end else begin
                    zero = 1'b0;
                end
                carry = 1'b0;
                overflow = 1'b0;
                negative = res[31];
            end

            LUI: begin
                res = {b[15:0], 16'b0};
                if (res == 32'd0) begin
                    zero = 1'b1;
                end else begin
                    zero = 1'b0;
                end
                carry = 1'b0;
                overflow = 1'b0;
                negative = res[31];
            end

            default: begin
                res = 32'bz;
                zero = 1'bz;
                carry = 1'bz;
                overflow = 1'bz;
                negative = 1'bz;
                flag = 1'bz;
            end
        endcase

        r = res;
        if (aluc == SLT || aluc == SLTU) begin
            flag = res[0];
        end else begin
            flag = 1'bz;
        end
    end

endmodule