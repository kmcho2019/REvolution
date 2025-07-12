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

    // Signed versions of inputs
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;

    // Parallel computation of all operations
    wire [31:0] add_res, addu_res, sub_res, subu_res;
    wire [31:0] and_res, or_res, xor_res, nor_res;
    wire [31:0] sll_res, srl_res, sra_res;
    wire [31:0] sllv_res, srlv_res, srav_res;
    wire [31:0] lui_res;
    wire slt_res, sltu_res;

    // Arithmetic operations with carry/overflow detection
    wire [32:0] add_ext = {signed_a[31], signed_a} + {signed_b[31], signed_b};
    wire [32:0] sub_ext = {signed_a[31], signed_a} - {signed_b[31], signed_b};
    wire [32:0] addu_ext = a + b;
    wire [32:0] subu_ext = a - b;

    assign add_res = add_ext[31:0];
    assign sub_res = sub_ext[31:0];
    assign addu_res = addu_ext[31:0];
    assign subu_res = subu_ext[31:0];

    // Logical operations
    assign and_res = a & b;
    assign or_res = a | b;
    assign xor_res = a ^ b;
    assign nor_res = ~(a | b);

    // Shift operations (using barrel shifter)
    assign sll_res = b << a[4:0];
    assign srl_res = b >> a[4:0];
    assign sra_res = $signed(b) >>> a[4:0];
    assign sllv_res = b << a[4:0];
    assign srlv_res = b >> a[4:0];
    assign srav_res = $signed(b) >>> a[4:0];

    // Comparison operations
    assign slt_res = signed_a < signed_b;
    assign sltu_res = a < b;

    // LUI operation
    assign lui_res = {b[15:0], 16'b0};

    // Result selection
    reg [31:0] result;
    always @(*) begin
        case (aluc)
            ADD:  result = add_res;
            ADDU: result = addu_res;
            SUB:  result = sub_res;
            SUBU: result = subu_res;
            AND:  result = and_res;
            OR:   result = or_res;
            XOR:  result = xor_res;
            NOR:  result = nor_res;
            SLT:  result = {31'b0, slt_res};
            SLTU: result = {31'b0, sltu_res};
            SLL:  result = sll_res;
            SRL:  result = srl_res;
            SRA:  result = sra_res;
            SLLV: result = sllv_res;
            SRLV: result = srlv_res;
            SRAV: result = srav_res;
            LUI:  result = lui_res;
            default: result = 32'b0;
        endcase
    end

    // Flag generation
    assign r = result;
    assign zero = (result == 32'b0);
    assign negative = result[31];
    
    // Carry flag (only for arithmetic operations)
    assign carry = (aluc == ADD || aluc == SUB) ? add_ext[32] : 
                  (aluc == ADDU || aluc == SUBU) ? addu_ext[32] : 1'b0;

    // Overflow detection
    wire add_ovf = (signed_a[31] == signed_b[31]) && (add_res[31] != signed_a[31]);
    wire sub_ovf = (signed_a[31] != signed_b[31]) && (sub_res[31] != signed_a[31]);
    assign overflow = (aluc == ADD) ? add_ovf : 
                     (aluc == SUB) ? sub_ovf : 1'b0;

    // Flag output (only for SLT/SLTU)
    assign flag = (aluc == SLT) ? slt_res : 
                  (aluc == SLTU) ? sltu_res : 1'b0;

endmodule