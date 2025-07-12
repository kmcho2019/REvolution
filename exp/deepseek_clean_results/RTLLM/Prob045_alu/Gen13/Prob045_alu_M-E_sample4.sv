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

    // Operation codes
    parameter ADD  = 6'b100000;
    parameter ADDU = 6'b100001;
    parameter SUB  = 6'b100010;
    parameter SUBU = 6'b100011;
    parameter AND  = 6'b100100;
    parameter OR   = 6'b100101;
    parameter XOR  = 6'b100110;
    parameter NOR  = 6'b100111;
    parameter SLT  = 6'b101010;
    parameter SLTU = 6'b101011;
    parameter SLL  = 6'b000000;
    parameter SRL  = 6'b000010;
    parameter SRA  = 6'b000011;
    parameter SLLV = 6'b000100;
    parameter SRLV = 6'b000110;
    parameter SRAV = 6'b000111;
    parameter LUI  = 6'b001111;

    // Internal wires
    wire [31:0] arith_result, logic_result, shift_result, comp_result;
    wire arith_carry, arith_overflow;
    wire comp_flag;
    wire [4:0] shift_amount;

    // Operation classification
    wire is_arith = (aluc == ADD)  || (aluc == ADDU) || 
                    (aluc == SUB)  || (aluc == SUBU);
    wire is_logic = (aluc == AND)  || (aluc == OR) || 
                    (aluc == XOR) || (aluc == NOR);
    wire is_shift = (aluc == SLL)  || (aluc == SRL)  || (aluc == SRA) || 
                    (aluc == SLLV) || (aluc == SRLV) || (aluc == SRAV);
    wire is_comp  = (aluc == SLT)  || (aluc == SLTU);
    wire is_lui   = (aluc == LUI);

    // Shift amount selection
    assign shift_amount = (aluc[3]) ? a[4:0] : b[4:0];

    // Arithmetic Unit
    arithmetic_unit arith_unit(
        .a(a),
        .b(b),
        .op(aluc[1:0]), // 00:ADD, 01:ADDU, 10:SUB, 11:SUBU
        .result(arith_result),
        .carry(arith_carry),
        .overflow(arith_overflow)
    );

    // Logical Unit
    logic_unit logic_unit(
        .a(a),
        .b(b),
        .op(aluc[1:0]), // 00:AND, 01:OR, 10:XOR, 11:NOR
        .result(logic_result)
    );

    // Shift Unit
    shift_unit shift_unit(
        .a(a),
        .b(b),
        .shift_amt(shift_amount),
        .op(aluc[2:0]), // Encodes all shift operations
        .result(shift_result)
    );

    // Comparison Unit
    compare_unit comp_unit(
        .a(a),
        .b(b),
        .unsigned_op(aluc[0]), // 0:SLT, 1:SLTU
        .result(comp_result),
        .flag(comp_flag)
    );

    // Result multiplexing
    assign r = is_arith ? arith_result :
               is_logic ? logic_result :
               is_shift ? shift_result :
               is_comp  ? comp_result :
               is_lui   ? {b[15:0], 16'b0} :
               32'b0;

    // Flag generation
    assign zero = (r == 32'b0);
    assign negative = r[31];
    assign carry = is_arith ? arith_carry : 1'b0;
    assign overflow = is_arith ? arith_overflow : 1'b0;
    assign flag = is_comp ? comp_flag : 1'b0;

endmodule

// Submodule: Arithmetic Unit
module arithmetic_unit(
    input [31:0] a,
    input [31:0] b,
    input [1:0] op, // 00:ADD, 01:ADDU, 10:SUB, 11:SUBU
    output reg [31:0] result,
    output reg carry,
    output reg overflow
);

    wire [32:0] sum = {1'b0, a} + {1'b0, b};
    wire [32:0] diff = {1'b0, a} - {1'b0, b};

    always @(*) begin
        case (op)
            2'b00: begin // ADD
                result = sum[31:0];
                carry = sum[32];
                overflow = (a[31] == b[31]) && (result[31] != a[31]);
            end
            2'b01: begin // ADDU
                result = sum[31:0];
                carry = sum[32];
                overflow = 1'b0;
            end
            2'b10: begin // SUB
                result = diff[31:0];
                carry = diff[32];
                overflow = (a[31] != b[31]) && (result[31] != a[31]);
            end
            2'b11: begin // SUBU
                result = diff[31:0];
                carry = diff[32];
                overflow = 1'b0;
            end
        endcase
    end
endmodule

// Submodule: Logic Unit
module logic_unit(
    input [31:0] a,
    input [31:0] b,
    input [1:0] op, // 00:AND, 01:OR, 10:XOR, 11:NOR
    output reg [31:0] result
);

    always @(*) begin
        case (op)
            2'b00: result = a & b;
            2'b01: result = a | b;
            2'b10: result = a ^ b;
            2'b11: result = ~(a | b);
        endcase
    end
endmodule

// Submodule: Shift Unit
module shift_unit(
    input [31:0] a,
    input [31:0] b,
    input [4:0] shift_amt,
    input [2:0] op, // Encodes all shift operations
    output reg [31:0] result
);

    wire signed [31:0] signed_b = b;

    always @(*) begin
        case (op)
            3'b000: result = b << shift_amt;  // SLL
            3'b010: result = b >> shift_amt;   // SRL
            3'b011: result = signed_b >>> shift_amt; // SRA
            3'b100: result = b << a[4:0];     // SLLV
            3'b110: result = b >> a[4:0];      // SRLV
            3'b111: result = signed_b >>> a[4:0]; // SRAV
            default: result = 32'b0;
        endcase
    end
endmodule

// Submodule: Compare Unit
module compare_unit(
    input [31:0] a,
    input [31:0] b,
    input unsigned_op,
    output reg [31:0] result,
    output reg flag
);

    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;

    always @(*) begin
        if (unsigned_op) begin
            result = (a < b) ? 32'b1 : 32'b0;
        end else begin
            result = (signed_a < signed_b) ? 32'b1 : 32'b0;
        end
        flag = result[0];
    end
endmodule