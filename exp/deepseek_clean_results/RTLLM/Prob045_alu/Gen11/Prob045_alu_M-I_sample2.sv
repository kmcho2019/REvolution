module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output negative,
    output reg overflow,
    output reg flag
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
    wire is_arith = (aluc == ADD) | (aluc == ADDU) | (aluc == SUB) | (aluc == SUBU);
    wire is_logic = (aluc == AND) | (aluc == OR) | (aluc == XOR) | (aluc == NOR);
    wire is_shift = (aluc == SLL) | (aluc == SRL) | (aluc == SRA) | 
                   (aluc == SLLV) | (aluc == SRLV) | (aluc == SRAV);
    wire is_comp = (aluc == SLT) | (aluc == SLTU);
    
    // Shared arithmetic unit
    wire [31:0] b_arith = (aluc[0] ? b : ~b) + {31'b0, ~aluc[0]}; // SUB/SUBU when aluc[0]=0
    wire [32:0] arith_result = {1'b0, a} + {1'b0, b_arith};
    
    // Unified barrel shifter
    wire [4:0] shift_amt = (aluc[3] ? a[4:0] : b[4:0]); // SxLV vs Sx
    wire [31:0] shift_in = (aluc[1] ? {32{b[31]}} : 32'b0); // SRA vs others
    wire [31:0] shifted_val = (aluc[2] ? 
                             ({shift_in, b} >> shift_amt) : // Right shifts
                             (b << shift_amt));            // Left shifts
    
    // Overflow detection
    wire add_ovf = ~a[31] & ~b_arith[31] & arith_result[31];
    wire sub_ovf = ~a[31] & b_arith[31] & arith_result[31];
    wire arith_ovf = (aluc == ADD) ? (add_ovf | sub_ovf) : 1'b0;
    
    always @(*) begin
        // Default values
        r = 32'b0;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
        
        // Operation selection
        case (1'b1)
            is_arith: begin
                r = arith_result[31:0];
                carry = arith_result[32];
                overflow = arith_ovf;
            end
            is_logic: begin
                case (aluc[2:0])
                    3'b100: r = a & b;
                    3'b101: r = a | b;
                    3'b110: r = a ^ b;
                    3'b111: r = ~(a | b);
                endcase
            end
            is_comp: begin
                if (aluc == SLT) 
                    flag = $signed(a) < $signed(b);
                else
                    flag = a < b;
                r = {31'b0, flag};
            end
            is_shift: begin
                r = shifted_val;
            end
            (aluc == LUI): begin
                r = {b[15:0], 16'b0};
            end
        endcase
    end

    assign zero = (r == 32'b0);
    assign negative = r[31];

endmodule