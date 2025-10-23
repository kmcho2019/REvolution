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

// Arithmetic Operations Module
module arithmetic(
    input [31:0] a,
    input [31:0] b,
    input [5:0] op,
    output [31:0] res,
    output carry,
    output overflow
);
    reg [31:0] res;
    reg carry;
    reg overflow;

    always @(a, b, op) begin
        case (op)
            6'b100000: begin // ADD
                {carry, res} = a + b;
                overflow = (a[31] == b[31] && a[31] != res[31]);
            end
            6'b100001: begin // ADDU
                {carry, res} = a + b;
                overflow = 1'b0;
            end
            6'b100010: begin // SUB
                {carry, res} = a - b;
                overflow = (a[31] != b[31] && a[31] != res[31]);
            end
            6'b100011: begin // SUBU
                {carry, res} = a - b;
                overflow = 1'b0;
            end
            default: begin
                res = 32'bz;
                carry = 1'bz;
                overflow = 1'bz;
            end
        endcase
    end
endmodule

// Bitwise Operations Module
module bitwise(
    input [31:0] a,
    input [31:0] b,
    input [5:0] op,
    output [31:0] res
);
    reg [31:0] res;

    always @(a, b, op) begin
        case (op)
            6'b100100: res = a & b; // AND
            6'b100101: res = a | b; // OR
            6'b100110: res = a ^ b; // XOR
            6'b100111: res = ~(a | b); // NOR
            default: res = 32'bz;
        endcase
    end
endmodule

// Shift Operations Module
module shift(
    input [31:0] a,
    input [4:0] shift_amount,
    input [1:0] op,
    output [31:0] res
);
    reg [31:0] res;

    always @(a, shift_amount, op) begin
        case (op)
            2'b00: res = a << shift_amount; // SLL
            2'b01: res = a >> shift_amount; // SRL
            2'b10: res = {a[31], a[31:1]}; // SRA (arithmetic right shift, assuming sign bit is in a[31])
            default: res = 32'bz;
        endcase
    end
endmodule

// Comparison Operations Module
module compare(
    input [31:0] a,
    input [31:0] b,
    input [5:0] op,
    output [31:0] res,
    output flag
);
    reg [31:0] res;
    reg flag;

    always @(a, b, op) begin
        case (op)
            6'b101010: begin // SLT
                if (a < b) begin
                    res = 32'd1;
                    flag = 1'b1;
                end else begin
                    res = 32'd0;
                    flag = 1'b0;
                end
            end
            6'b101011: begin // SLTU
                if (a < b) begin
                    res = 32'd1;
                    flag = 1'b1;
                end else begin
                    res = 32'd0;
                    flag = 1'b0;
                end
            end
            default: begin
                res = 32'bz;
                flag = 1'bz;
            end
        endcase
    end
endmodule

// Instantiation of sub-modules
wire [31:0] arith_res;
wire [31:0] bitwise_res;
wire [31:0] shift_res;
wire [31:0] compare_res;
reg [31:0] r;
reg zero;
reg carry;
reg negative;
reg overflow;
reg flag;

arithmetic arith_unit(a, b, aluc, arith_res, carry, overflow);
bitwise bitwise_unit(a, b, aluc, bitwise_res);
shift shift_unit(a, a[4:0], aluc[1:0], shift_res);
compare compare_unit(a, b, aluc, compare_res, flag);

// Top-level logic to route results
always @(arith_res, bitwise_res, shift_res, compare_res, aluc) begin
    case (aluc[5:4])
        2'b00: r = shift_res; // Shift operations
        2'b01: r = bitwise_res; // Bitwise operations
        2'b10: r = arith_res; // Arithmetic operations
        2'b11: r = compare_res; // Comparison operations
        default: r = 32'bz;
    endcase
end

// Output logic
assign zero = (r == 32'd0);
assign negative = r[31];
assign flag = flag;

endmodule