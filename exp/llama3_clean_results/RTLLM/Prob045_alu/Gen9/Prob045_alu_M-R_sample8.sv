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

// Operation Selection and Execution
reg [31:0] result;
reg zero_int;
reg carry_int;
reg negative_int;
reg overflow_int;
reg flag_int;

always @(*) begin
    case (aluc)
        ADD, ADDU: begin
            result = a + b;
            zero_int = (result == 0);
            carry_int = (a[31] == b[31] && a[31]!= result[31]);
            negative_int = result[31];
            overflow_int = (a[31] == b[31] && a[31]!= result[31]);
            flag_int = 0;
        end
        SUB, SUBU: begin
            result = a - b;
            zero_int = (result == 0);
            carry_int = (a[31]!= b[31] && a[31] == result[31]);
            negative_int = result[31];
            overflow_int = (a[31]!= b[31] && a[31] == result[31]);
            flag_int = 0;
        end
        AND: begin
            result = a & b;
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = 0;
        end
        OR: begin
            result = a | b;
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = 0;
        end
        XOR: begin
            result = a ^ b;
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = 0;
        end
        NOR: begin
            result = ~(a | b);
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = 0;
        end
        SLT: begin
            result = (signed'(a) < signed'(b))? 32'd1 : 32'd0;
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = (signed'(a) < signed'(b));
        end
        SLTU: begin
            result = (a < b)? 32'd1 : 32'd0;
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = (a < b);
        end
        SLL: begin
            result = a << b[4:0];
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = 0;
        end
        SRL: begin
            result = a >> b[4:0];
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = 0;
        end
        SRA: begin
            result = a >>> b[4:0];
            zero_int = (result == 0);
            carry_int = 0;
            negative_int = result[31];
            overflow_int = 0;
            flag_int = 0;
        end
        LUI: begin
            result = {b[15:0], 16'd0};
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

// Output Assignment
assign r = result;
assign zero = zero_int;
assign carry = carry_int;
assign negative = negative_int;
assign overflow = overflow_int;
assign flag = flag_int;

endmodule