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

    // Bit-slice configuration
    wire [3:0] slice_enable;
    wire [31:0] slice_result [0:7];
    wire [7:0] slice_carry, slice_zero, slice_negative;

    // Dynamic precision detection
    wire [2:0] active_slices;
    assign active_slices = (|a[31:28]) ? 3'd7 :
                          (|a[27:24]) ? 3'd6 :
                          (|a[23:20]) ? 3'd5 :
                          (|a[19:16]) ? 3'd4 :
                          (|a[15:12]) ? 3'd3 :
                          (|a[11:8])  ? 3'd2 :
                          (|a[7:4])   ? 3'd1 : 3'd0;

    // Slice enable generation
    assign slice_enable = (is_arith && aluc[0]) ? 4'b1111 : // Full precision for ADDU/SUBU
                         (is_arith) ? (4'b1111 >> (3-active_slices)) : // Dynamic for ADD/SUB
                         4'b1111; // Full for others

    // Operation classification
    wire is_arith = |{aluc == ADD, aluc == ADDU, aluc == SUB, aluc == SUBU};
    wire is_logic = |{aluc == AND, aluc == OR, aluc == XOR, aluc == NOR};
    wire is_shift = |{aluc == SLL, aluc == SRL, aluc == SRA, 
                     aluc == SLLV, aluc == SRLV, aluc == SRAV};
    wire is_comp = |{aluc == SLT, aluc == SLTU};
    wire is_lui = (aluc == LUI);

    // Generate 8x4-bit slices
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : slice
            // Local operands
            wire [3:0] a_slice = a[(i*4)+3 : i*4];
            wire [3:0] b_slice = b[(i*4)+3 : i*4];
            
            // Arithmetic unit
            wire add_sub = |{aluc == SUB, aluc == SUBU};
            wire [4:0] arith_result = {1'b0, a_slice} + 
                                      {1'b0, add_sub ? ~b_slice : b_slice} + 
                                      {4'b0, add_sub};
            
            // Logic unit
            wire [3:0] logic_result = 
                (aluc == AND) ? (a_slice & b_slice) :
                (aluc == OR)  ? (a_slice | b_slice) :
                (aluc == XOR) ? (a_slice ^ b_slice) :
                (aluc == NOR) ? ~(a_slice | b_slice) : 4'b0;
            
            // Result selection
            assign slice_result[i] = 
                is_arith ? {28'b0, arith_result[3:0]} :
                is_logic ? {28'b0, logic_result} :
                is_comp ? (i == 0 ? {31'b0, 
                                    (aluc == SLT) ? ($signed(a) < $signed(b)) : 
                                    (a < b)} : 32'b0) :
                is_lui  ? (i >= 4 ? {28'b0, b[15:0]} : 32'b0) : 32'b0;
            
            // Flag generation
            assign slice_carry[i] = is_arith && arith_result[4];
            assign slice_zero[i] = (slice_result[i] == 32'b0);
            assign slice_negative[i] = slice_result[i][31];
        end
    endgenerate

    // Result aggregation
    always @(*) begin
        r = 32'b0;
        if (is_shift) begin
            case (aluc[2:0])
                3'b000: r = b << (aluc[3] ? a[4:0] : b[4:0]);  // SLL/SLLV
                3'b010: r = b >> (aluc[3] ? a[4:0] : b[4:0]);  // SRL/SRLV
                3'b011: r = $signed(b) >>> (aluc[3] ? a[4:0] : b[4:0]); // SRA/SRAV
            endcase
        end else begin
            for (integer j = 0; j < 8; j = j + 1) begin
                r = r | slice_result[j];
            end
        end
    end

    // Flag generation
    assign zero = &slice_zero;
    assign carry = |slice_carry;
    assign negative = |slice_negative;
    
    // Overflow detection
    wire [31:0] arith_result_full;
    assign arith_result_full = a + (aluc[1] ? ~b : b) + {31'b0, aluc[1]};
    assign overflow = (is_arith && ~aluc[0]) ? 
                     ((~a[31] & ~(aluc[1] ? ~b[31] : b[31]) & arith_result_full[31]) |
                     (a[31] & (aluc[1] ? ~b[31] : b[31]) & ~arith_result_full[31]) : 1'b0;
    
    assign flag = is_comp;

endmodule