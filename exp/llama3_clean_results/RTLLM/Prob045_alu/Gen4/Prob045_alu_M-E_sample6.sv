module hybrid_alu(
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

// Reconfigurable blocks
wire [31:0] arith_result;
wire [31:0] logic_result;
wire [31:0] shift_result;

// Slow path (multiplier and divider)
wire [31:0] mult_result;
wire [31:0] div_result;

// Control unit
reg [31:0] res;
reg z, c, n, v, f;

// Assign outputs
assign r = res;
assign zero = (res == 0);
assign negative = res[31];

// Reconfigurable blocks
always @(a, b, aluc) begin
    case (aluc)
        ADD: arith_result = a + b;
        ADDU: arith_result = a + b;
        SUB: arith_result = a - b;
        SUBU: arith_result = a - b;
        AND: logic_result = a & b;
        OR: logic_result = a | b;
        XOR: logic_result = a ^ b;
        NOR: logic_result = ~(a | b);
        SLT: logic_result = (signed'(a) < signed'(b))? 32'd1 : 32'd0;
        SLTU: logic_result = (a < b)? 32'd1 : 32'd0;
        SLL: shift_result = a << b[4:0];
        SRL: shift_result = a >> b[4:0];
        SRA: shift_result = a >>> b[4:0];
        SLLV: shift_result = a << a[4:0];
        SRLV: shift_result = a >> a[4:0];
        SRAV: shift_result = a >>> a[4:0];
        LUI: res = {a[15:0], 16'd0};
    endcase
end

// Slow path (multiplier and divider)
always @(a, b, aluc) begin
    case (aluc)
        ADD: mult_result = a * b;
        SUB: div_result = a / b;
    endcase
end

// Control unit
always @(arith_result, logic_result, shift_result, mult_result, div_result, aluc) begin
    case (aluc)
        ADD: res = arith_result;
        ADDU: res = arith_result;
        SUB: res = arith_result;
        SUBU: res = arith_result;
        AND: res = logic_result;
        OR: res = logic_result;
        XOR: res = logic_result;
        NOR: res = logic_result;
        SLT: res = logic_result;
        SLTU: res = logic_result;
        SLL: res = shift_result;
        SRL: res = shift_result;
        SRA: res = shift_result;
        SLLV: res = shift_result;
        SRLV: res = shift_result;
        SRAV: res = shift_result;
        LUI: res = {a[15:0], 16'd0};
    endcase
end

// Flag generation
always @(aluc, res) begin
    case (aluc)
        SLT: f = (signed'(a) < signed'(b));
        SLTU: f = (a < b);
    endcase
end

// Overflow and carry generation
always @(aluc, res) begin
    case (aluc)
        ADD: begin
            v = (a[31] == b[31] && a[31]!= res[31]);
            c = (a + b) > 32'd4294967295;
        end
        ADDU: begin
            v = 0;
            c = (a + b) > 32'd4294967295;
        end
        SUB: begin
            v = (a[31]!= b[31] && a[31]!= res[31]);
            c = (a - b) < 0;
        end
        SUBU: begin
            v = 0;
            c = (a - b) < 0;
        end
    endcase
end

assign overflow = v;
assign carry = c;
assign flag = f;

endmodule