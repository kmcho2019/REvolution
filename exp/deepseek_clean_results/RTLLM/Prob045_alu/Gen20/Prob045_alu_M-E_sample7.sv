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

    // Operation classification
    wire is_arith = (aluc == ADD) || (aluc == ADDU) || (aluc == SUB) || (aluc == SUBU);
    wire is_logic = (aluc == AND) || (aluc == OR) || (aluc == XOR) || (aluc == NOR);
    wire is_shift = (aluc == SLL) || (aluc == SRL) || (aluc == SRA) || 
                   (aluc == SLLV) || (aluc == SRLV) || (aluc == SRAV);
    wire is_comp  = (aluc == SLT) || (aluc == SLTU);
    wire is_lui   = (aluc == LUI);

    // Parallel arithmetic units
    wire [32:0] add_result = {1'b0, a} + {1'b0, b};  // 33-bit for carry
    wire [32:0] sub_result = {1'b0, a} - {1'b0, b};  // 33-bit for carry
    
    // Unified barrel shifter
    wire [4:0] shift_amount = (aluc[3]) ? a[4:0] : b[4:0]; // SxV ops use a[4:0]
    wire [31:0] shifted_val;
    
    barrel_shifter shifter(
        .data_in(b),
        .shift_amt(shift_amount),
        .shift_mode(aluc[1:0]), // 00:SLL, 10:SRL, 11:SRA
        .data_out(shifted_val)
    );

    // Flag generators (parallel computation)
    assign zero = (r == 32'b0);
    assign negative = r[31];
    
    // Overflow detection
    wire add_ovf = ~aluc[0] & (a[31] == b[31]) & (add_result[31] != a[31]);
    wire sub_ovf = ~aluc[0] & (a[31] != b[31]) & (sub_result[31] != a[31]);
    assign overflow = (aluc == ADD) ? add_ovf : 
                    (aluc == SUB) ? sub_ovf : 1'b0;
    
    // Carry detection
    assign carry = is_arith & ((aluc[1] ? sub_result[32] : add_result[32]));
    
    // Comparison flag (direct computation)
    wire signed_lt = $signed(a) < $signed(b);
    wire unsigned_lt = a < b;
    assign flag = is_comp & ((aluc[0] ? unsigned_lt : signed_lt));

    // Result selection
    always @(*) begin
        case (aluc)
            ADD, ADDU: r = add_result[31:0];
            SUB, SUBU: r = sub_result[31:0];
            AND:      r = a & b;
            OR:       r = a | b;
            XOR:      r = a ^ b;
            NOR:      r = ~(a | b);
            SLT, SLTU: r = {31'b0, flag}; // Direct flag assignment
            SLL, SLLV, SRL, SRLV, SRA, SRAV: r = shifted_val;
            LUI:      r = {b[15:0], 16'b0};
            default:  r = 32'b0;
        endcase
    end

endmodule

// Unified barrel shifter module
module barrel_shifter(
    input [31:0] data_in,
    input [4:0] shift_amt,
    input [1:0] shift_mode, // 00:SLL, 10:SRL, 11:SRA
    output reg [31:0] data_out
);
    always @(*) begin
        case (shift_mode)
            2'b00: data_out = data_in << shift_amt; // SLL
            2'b10: data_out = data_in >> shift_amt; // SRL
            2'b11: data_out = $signed(data_in) >>> shift_amt; // SRA
            default: data_out = data_in;
        endcase
    end
endmodule