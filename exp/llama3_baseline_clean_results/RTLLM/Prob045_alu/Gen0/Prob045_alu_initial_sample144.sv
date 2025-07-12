module alu(
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

    parameter ADD    = 6'b100000;
    parameter ADDU   = 6'b100001;
    parameter SUB    = 6'b100010;
    parameter SUBU   = 6'b100011;
    parameter AND    = 6'b100100;
    parameter OR     = 6'b100101;
    parameter XOR    = 6'b100110;
    parameter NOR    = 6'b100111;
    parameter SLT    = 6'b101010;
    parameter SLTU   = 6'b101011;
    parameter SLL    = 6'b000000;
    parameter SRL    = 6'b000010;
    parameter SRA    = 6'b000011;
    parameter SLLV   = 6'b000100;
    parameter SRLV   = 6'b000110;
    parameter SRAV   = 6'b000111;
    parameter LUI    = 6'b001111;

    reg [31:0] res;
    reg         z, c, n, o, f;

    always @(*) begin
        case(aluc)
            ADD: begin
                res = a + b;
                c   = (a[31] == b[31] && res[31]!= a[31]);
                o   = (a[31] == b[31] && res[31]!= a[31]);
                z   = (res == 32'd0);
                n   = res[31];
                f   = 1'b0;
            end

            ADDU: begin
                res = a + b;
                c   = (a[31] == b[31] && res[31]!= a[31]);
                o   = 1'b0;
                z   = (res == 32'd0);
                n   = res[31];
                f   = 1'b0;
            end

            SUB: begin
                res = a - b;
                c   = (a[31] == b[31] && res[31]!= a[31]);
                o   = (a[31] == b[31] && res[31]!= a[31]);
                z   = (res == 32'd0);
                n   = res[31];
                f   = 1'b0;
            end

            SUBU: begin
                res = a - b;
                c   = (a[31] == b[31] && res[31]!= a[31]);
                o   = 1'b0;
                z   = (res == 32'd0);
                n   = res[31];
                f   = 1'b0;
            end

            AND: begin
                res = a & b;
                c   = 1'b0;
                o   = 1'b0;
                z   = (res == 32'd0);
                n   = res[31];
                f   = 1'b0;
            end

            OR: begin
                res = a | b;
                c   = 1'b0;
                o   = 1'b0;
                z   = (res == 32'd0);
                n   = res[31];
                f   = 1'b0;
            end

            XOR: begin
                res = a ^ b;
                c   = 1'b0;
                o   = 1'b0;
                z   = (res == 32'd0);
                n   = res[31];
                f   = 1'b0;
            end

            NOR: begin
                res = ~(a | b);
                c   = 1'b0;
                o   = 1'b0;
                z   = (res == 32'd0);
                n   = res[31];
                f   = 1'b0;
            end

            SLT: begin
                res = ($signed(a) < $signed(b))? 32'd1 : 32'd0;
                c   = 1'b0;
                o   = 1'b0;
                z   = (res == 32'd0);
                n   = res[31];
                f   = 1'b1;
            end

            SLTU: begin
                res = (a < b)? 32'd1 : 32'd0;
                c   = 1'b0;
                o   = 1'b0;
                z   = (res == 32'd0);
                n   = res[31];
                f   = 1'b1;
            end

            SLL: begin
                res = a << b[4:0];
                c   = 1'b0;
                o   = 1'b0;
                z   = (res == 32'd0);
                n   = res[31];
                f   = 1'b0;
            end

            SRL: begin
                res = a >> b[4:0];
                c   = 1'b0;
                o   = 1'b0;
                z   = (res == 32'd0);
                n   = res[31];
                f   = 1'b0;
            end

            SRA: begin
                res = a >>> b[4:0];
                c   = 1'b0;
                o   = 1'b0;
                z   = (res == 32'd0);
                n   = res[31];
                f   = 1'b0;
            end

            SLLV: begin
                res = a << b[4:0];
                c   = 1'b0;
                o   = 1'b0;
                z   = (res == 32'd0);
                n   = res[31];
                f   = 1'b0;
            end

            SRLV: begin
                res = a >> b[4:0];
                c   = 1'b0;
                o   = 1'b0;
                z   = (res == 32'd0);
                n   = res[31];
                f   = 1'b0;
            end

            SRAV: begin
                res = a >>> b[4:0];
                c   = 1'b0;
                o   = 1'b0;
                z   = (res == 32'd0);
                n   = res[31];
                f   = 1'b0;
            end

            LUI: begin
                res = {a[15:0], 16'd0};
                c   = 1'b0;
                o   = 1'b0;
                z   = (res == 32'd0);
                n   = res[31];
                f   = 1'b0;
            end

            default: begin
                res = 32'bz;
                c   = 1'bz;
                o   = 1'bz;
                z   = 1'bz;
                n   = 1'bz;
                f   = 1'bz;
            end
        endcase
    end

    assign r      = res;
    assign zero   = z;
    assign carry  = c;
    assign negative = n;
    assign overflow = o;
    assign flag   = f;

endmodule