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

// Define parameters for operations
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

// Stage 1: Operation Selection
wire [31:0] op_a;
wire [31:0] op_b;
wire [5:0] op_aluc;
wire sel;

always @(*) begin
    case (aluc)
        ADD, ADDU, SUB, SUBU: begin
            op_a = a;
            op_b = b;
            op_aluc = aluc;
            sel = 1'b1;
        end
        AND, OR, XOR, NOR: begin
            op_a = a;
            op_b = b;
            op_aluc = aluc;
            sel = 1'b0;
        end
        SLT, SLTU: begin
            op_a = a;
            op_b = b;
            op_aluc = aluc;
            sel = 1'b1;
        end
        SLL, SRL, SRA, SLLV, SRLV, SRAV: begin
            op_a = a;
            op_b = b;
            op_aluc = aluc;
            sel = 1'b0;
        end
        LUI: begin
            op_a = 32'd0;
            op_b = b;
            op_aluc = aluc;
            sel = 1'b0;
        end
        default: begin
            op_a = 32'd0;
            op_b = 32'd0;
            op_aluc = 6'd0;
            sel = 1'b0;
        end
    endcase
end

// Stage 2: Operation Execution
wire [31:0] result;
wire zero_int;
wire carry_int;
wire negative_int;
wire overflow_int;
wire flag_int;

always @(*) begin
    case (op_aluc)
        ADD, ADDU: begin
            result = op_a + op_b;
            zero_int = (result == 0);
            carry_int = (op_a[31] == op_b[31] && op_a[31]!= result[31]);
            negative_int = result[31];
            overflow_int = (op_a[31] == op_b[31] && op_a[31]!= result[31]);
            flag_int = 0;
        end
        SUB, SUBU: begin
            result = op_a - op_b;
            zero_int = (result == 0);
            carry_int = (op_a[31]!= op_b[31] && op_a[31] == result[31]);
            negative_int = result[31];
            overflow_int = (op_a[31]!= op_b[31] && op_a[31] == result[31]);
            flag_int = 0;
        end
        AND: begin
            result = op_a & op_b;
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = 0;
        end
        OR: begin
            result = op_a | op_b;
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = 0;
        end
        XOR: begin
            result = op_a ^ op_b;
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = 0;
        end
        NOR: begin
            result = ~(op_a | op_b);
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = 0;
        end
        SLT: begin
            result = (signed'(op_a) < signed'(op_b))? 32'd1 : 32'd0;
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = (signed'(op_a) < signed'(op_b));
        end
        SLTU: begin
            result = (op_a < op_b)? 32'd1 : 32'd0;
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = (op_a < op_b);
        end
        SLL: begin
            result = op_a << op_b[4:0];
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = 0;
        end
        SRL: begin
            result = op_a >> op_b[4:0];
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = 0;
        end
        SRA: begin
            result = op_a >>> op_b[4:0];
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = 0;
        end
        LUI: begin
            result = {op_b[15:0], 16'd0};
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = 0;
        end
        default: begin
            result = 32'd0;
            zero_int = 0;
            carry_int = 0;
            negative_int = 0;
            overflow_int = 0;
            flag_int = 0;
        end
    endcase
end

// Flag Generation Unit
always @(*) begin
    zero = zero_int;
    carry = carry_int;
    negative = negative_int;
    overflow = overflow_int;
    flag = flag_int;
end

// Output Assignment
assign r = result;

endmodule