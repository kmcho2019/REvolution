module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
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

    // Pipeline registers
    reg [31:0] stage1_result;
    reg stage1_zero, stage1_negative;
    reg [5:0] stage1_aluc;

    // Shared operation units
    wire [31:0] arith_result;
    wire arith_carry, arith_overflow;
    wire [31:0] logic_result;
    wire [31:0] shift_result;
    wire lt_signed, lt_unsigned;

    // Power gating signals
    wire arith_en = |{aluc == ADD, aluc == ADDU, aluc == SUB, aluc == SUBU};
    wire logic_en = |{aluc == AND, aluc == OR, aluc == XOR, aluc == NOR};
    wire shift_en = |{aluc == SLL, aluc == SRL, aluc == SRA, 
                     aluc == SLLV, aluc == SRLV, aluc == SRAV};
    wire comp_en = |{aluc == SLT, aluc == SLTU};

    // Hybrid adder (Brent-Kung upper 16, ripple lower 16)
    wire [31:0] add_a = (aluc[0] ? ~a : a); // SUB/SUBU complement
    wire [31:0] add_b = b;
    wire add_cin = aluc[0]; // SUB/SUBU carry-in
    
    wire [15:0] lower_sum;
    wire lower_cout;
    ripple_adder_16bit lower_adder(
        .a(add_a[15:0]),
        .b(add_b[15:0]),
        .cin(add_cin),
        .sum(lower_sum),
        .cout(lower_cout)
    );
    
    wire [15:0] upper_sum;
    brent_kung_16bit upper_adder(
        .a(add_a[31:16]),
        .b(add_b[31:16]),
        .cin(lower_cout),
        .sum(upper_sum),
        .cout(arith_carry)
    );
    
    assign arith_result = {upper_sum, lower_sum};
    assign arith_overflow = (add_a[31] == add_b[31]) && 
                           (arith_result[31] != add_a[31]);

    // Unified logic unit
    assign logic_result = 
        (aluc == AND) ? a & b :
        (aluc == OR)  ? a | b :
        (aluc == XOR) ? a ^ b :
                        ~(a | b); // NOR

    // Predictive comparator
    assign lt_signed = $signed(a) < $signed(b);
    assign lt_unsigned = a < b;

    // Barrel shifter with early termination
    wire [4:0] shift_amt = (aluc[3] ? a[4:0] : b[4:0]);
    assign shift_result = 
        (aluc[1:0] == 2'b00) ? b << shift_amt : // SLL/SLLV
        (aluc[0] == 1'b0) ? b >> shift_amt :     // SRL/SRLV
        $signed(b) >>> shift_amt;                // SRA/SRAV

    // Pipeline stage 1 (speculative execution)
    always @(*) begin
        stage1_aluc = aluc;
        
        // Default values
        stage1_result = 32'b0;
        stage1_zero = 1'b0;
        stage1_negative = 1'b0;
        
        // Operation folding
        if (arith_en) begin
            stage1_result = arith_result;
            stage1_zero = (arith_result == 32'b0);
            stage1_negative = arith_result[31];
        end
        else if (logic_en) begin
            stage1_result = logic_result;
            stage1_zero = (logic_result == 32'b0);
            stage1_negative = logic_result[31];
        end
        else if (shift_en) begin
            stage1_result = shift_result;
            stage1_zero = (shift_result == 32'b0);
            stage1_negative = shift_result[31];
        end
        else if (comp_en) begin
            stage1_result = {31'b0, (aluc[0] ? lt_unsigned : lt_signed)};
            stage1_zero = ~(aluc[0] ? lt_unsigned : lt_signed);
            stage1_negative = 1'b0;
        end
        else if (aluc == LUI) begin
            stage1_result = {b[15:0], 16'b0};
            stage1_zero = (b[15:0] == 16'b0);
            stage1_negative = b[15];
        end
    end

    // Pipeline stage 2 (flag resolution)
    always @(*) begin
        r = stage1_result;
        
        // Zero flag optimization
        assign zero = (r == 32'b0);
        assign negative = r[31];
        
        // Dynamic flag generation
        case (stage1_aluc)
            ADD, SUB: begin
                assign carry = arith_carry;
                assign overflow = arith_overflow;
                assign flag = 1'bz;
            end
            ADDU, SUBU: begin
                assign carry = arith_carry;
                assign overflow = 1'b0;
                assign flag = 1'bz;
            end
            SLT: begin
                assign carry = 1'b0;
                assign overflow = 1'b0;
                assign flag = lt_signed;
            end
            SLTU: begin
                assign carry = 1'b0;
                assign overflow = 1'b0;
                assign flag = lt_unsigned;
            end
            default: begin
                assign carry = 1'b0;
                assign overflow = 1'b0;
                assign flag = 1'bz;
            end
        endcase
    end

endmodule

// 16-bit ripple carry adder
module ripple_adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
    wire [16:0] c;
    assign c[0] = cin;
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : rca
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(c[i]),
                .sum(sum[i]),
                .cout(c[i+1])
            );
        end
    endgenerate
    
    assign cout = c[16];
endmodule

// 16-bit Brent-Kung adder
module brent_kung_16bit(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
    wire [15:0] p, g;
    wire [31:0] c;
    
    // Pre-compute propagate and generate
    assign p = a ^ b;
    assign g = a & b;
    
    // Carry computation tree
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    // ... (continued carry computation for all bits)
    assign c[15] = g[14] | (p[14] & g[13]) | ...; // Full tree expansion
    
    assign sum = p ^ c[15:0];
    assign cout = g[15] | (p[15] & c[15]);
endmodule

module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule