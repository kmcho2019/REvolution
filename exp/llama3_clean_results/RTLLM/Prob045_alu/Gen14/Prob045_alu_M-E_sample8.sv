// Arithmetic Module
module arithmetic_module(
    input [31:0] a,
    input [31:0] b,
    input [1:0] op,
    output reg [31:0] result,
    output reg carry,
    output reg overflow
);
    
    always @(*) begin
        case (op)
            2'b00: begin // ADD
                {carry, result} = a + b;
                overflow = (a[31] == b[31] && a[31] != result[31]);
            end
            2'b01: begin // SUB
                {carry, result} = a - b;
                overflow = (a[31] != b[31] && a[31] != result[31]);
            end
            2'b10: begin // ADDU
                {carry, result} = a + b;
                overflow = 1'b0;
            end
            2'b11: begin // SUBU
                {carry, result} = a - b;
                overflow = 1'b0;
            end
            default: result = 32'bx;
        endcase
    end
endmodule

// Logical Module
module logical_module(
    input [31:0] a,
    input [31:0] b,
    input [1:0] op,
    output reg [31:0] result
);
    
    always @(*) begin
        case (op)
            2'b00: result = a & b; // AND
            2'b01: result = a | b; // OR
            2'b10: result = a ^ b; // XOR
            2'b11: result = ~(a | b); // NOR
            default: result = 32'bx;
        endcase
    end
endmodule

// Shift Module
module shift_module(
    input [31:0] a,
    input [4:0] shift_amount,
    input [1:0] op,
    output reg [31:0] result
);
    
    always @(*) begin
        case (op)
            2'b00: result = a << shift_amount; // SLL
            2'b01: result = a >> shift_amount; // SRL
            2'b10: result = a >>> shift_amount; // SRA
            default: result = 32'bx;
        endcase
    end
endmodule

// Comparison Module
module comparison_module(
    input [31:0] a,
    input [31:0] b,
    input op,
    output reg [31:0] result,
    output reg flag
);
    
    always @(*) begin
        if (op) begin // SLT
            result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            flag = ($signed(a) < $signed(b));
        end else begin // SLTU
            result = (a < b) ? 32'd1 : 32'd0;
            flag = (a < b);
        end
    end
endmodule

// Control Module
module control_module(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);
    
    wire [31:0] arithmetic_result;
    wire [31:0] logical_result;
    wire [31:0] shift_result;
    wire [31:0] comparison_result;
    wire arithmetic_carry;
    wire arithmetic_overflow;
    wire comparison_flag;
    
    arithmetic_module arithmetic_unit(
        .a(a),
        .b(b),
        .op(aluc[1:0]),
        .result(arithmetic_result),
        .carry(arithmetic_carry),
        .overflow(arithmetic_overflow)
    );
    
    logical_module logical_unit(
        .a(a),
        .b(b),
        .op(aluc[3:2]),
        .result(logical_result)
    );
    
    shift_module shift_unit(
        .a(a),
        .shift_amount(b[4:0]),
        .op(aluc[3:2]),
        .result(shift_result)
    );
    
    comparison_module comparison_unit(
        .a(a),
        .b(b),
        .op(aluc[0]),
        .result(comparison_result),
        .flag(comparison_flag)
    );
    
    always @(*) begin
        case (aluc[5:4])
            2'b00: r = arithmetic_result; // Arithmetic operations
            2'b01: r = logical_result; // Logical operations
            2'b10: r = shift_result; // Shift operations
            2'b11: r = comparison_result; // Comparison operations
            default: r = 32'bx;
        endcase
        
        carry = arithmetic_carry;
        overflow = arithmetic_overflow;
        flag = comparison_flag;
        zero = (r == 32'd0);
        negative = r[31];
    end
endmodule

// ALU Module
module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);
    
    control_module control_unit(
        .a(a),
        .b(b),
        .aluc(aluc),
        .r(r),
        .zero(zero),
        .carry(carry),
        .negative(negative),
        .overflow(overflow),
        .flag(flag)
    );
endmodule