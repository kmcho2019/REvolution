module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output reg flag
);

    // Operation codes grouped by type
    localparam [1:0] 
        ARITH = 2'b00,
        LOGIC = 2'b01,
        SHIFT = 2'b10,
        COMP  = 2'b11;
    
    // Arithmetic operations
    localparam 
        ADD  = 6'b100000,
        ADDU = 6'b100001,
        SUB  = 6'b100010,
        SUBU = 6'b100011;
    
    // Logical operations
    localparam 
        AND = 6'b100100,
        OR  = 6'b100101,
        XOR = 6'b100110,
        NOR = 6'b100111;
    
    // Shift operations
    localparam 
        SLL  = 6'b000000,
        SRL  = 6'b000010,
        SRA  = 6'b000011,
        SLLV = 6'b000100,
        SRLV = 6'b000110,
        SRAV = 6'b000111,
        LUI  = 6'b001111;
    
    // Comparison operations
    localparam 
        SLT  = 6'b101010,
        SLTU = 6'b101011;

    // Internal signals
    wire [1:0] op_type = aluc[5:4] == 2'b10 ? COMP : 
                        aluc[5] ? ARITH : 
                        aluc[3] ? SHIFT : LOGIC;
    
    // Operation results
    wire [31:0] arith_res, logic_res, shift_res, comp_res;
    wire [32:0] arith_res_ext;
    
    // Flag pre-computation
    wire zero_raw, negative_raw, carry_raw, overflow_raw;
    wire [31:0] result_bus;
    
    // Arithmetic Unit
    assign arith_res_ext = 
        (aluc == ADD)  ? {a[31], a} + {b[31], b} :
        (aluc == ADDU) ? {1'b0, a} + {1'b0, b} :
        (aluc == SUB)  ? {a[31], a} - {b[31], b} :
                         {1'b0, a} - {1'b0, b};  // SUBU
    
    assign arith_res = arith_res_ext[31:0];
    
    // Logic Unit
    assign logic_res = 
        (aluc == AND) ? a & b :
        (aluc == OR)  ? a | b :
        (aluc == XOR) ? a ^ b :
                        ~(a | b);  // NOR
    
    // Unified Shifter
    wire [4:0] shift_amount = 
        (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    assign shift_res = 
        (aluc == SLL || aluc == SLLV)  ? b << shift_amount :
        (aluc == SRL || aluc == SRLV)  ? b >> shift_amount :
        (aluc == SRA || aluc == SRAV)  ? $signed(b) >>> shift_amount :
        {b[15:0], 16'b0};  // LUI
    
    // Comparison Unit
    assign comp_res = {31'b0, 
        (aluc == SLT)  ? ($signed(a) < $signed(b)) :
                         (a < b)};  // SLTU
    
    // Result multiplexing
    assign result_bus = 
        (op_type == ARITH) ? arith_res :
        (op_type == LOGIC) ? logic_res :
        (op_type == SHIFT) ? shift_res : comp_res;
    
    // Early Zero Detection
    wire [7:0] zero_byte = 
        result_bus[31:24] | result_bus[23:16] | 
        result_bus[15:8] | result_bus[7:0];
    assign zero_raw = (zero_byte == 8'b0);
    
    // Flag Generation
    assign negative_raw = result_bus[31];
    assign carry_raw = arith_res_ext[32] & (op_type == ARITH);
    
    assign overflow_raw = 
        (aluc == ADD) ? ((a[31] == b[31]) && (result_bus[31] != a[31])) :
        (aluc == SUB) ? ((a[31] != b[31]) && (result_bus[31] != a[31])) : 1'b0;
    
    // Output stage
    always @(*) begin
        r = result_bus;
        flag = (op_type == COMP) ? result_bus[0] : 1'bz;
    end
    
    // Final flag outputs
    assign zero = zero_raw;
    assign negative = negative_raw;
    assign carry = carry_raw;
    assign overflow = overflow_raw;

endmodule