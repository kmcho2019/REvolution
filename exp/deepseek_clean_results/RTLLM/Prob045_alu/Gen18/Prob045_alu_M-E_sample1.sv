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

    // Segment processing units
    wire [7:0] pu_res [0:3][0:15]; // [segment][operation]
    wire [3:0] pu_carry, pu_zero, pu_neg;
    wire [3:0] pu_ovfl;

    // Operation encoding for speculative execution
    localparam [3:0] 
        OP_ADD = 0, OP_SUB = 1, OP_AND = 2, OP_OR = 3,
        OP_XOR = 4, OP_NOR = 5, OP_SLT = 6, OP_SLTU = 7,
        OP_SLL = 8, OP_SRL = 9, OP_SRA = 10, OP_LUI = 11;

    // Generate processing units
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : SEGMENTS
            // Segment operands
            wire [7:0] a_seg = a[(i*8)+7 : i*8];
            wire [7:0] b_seg = b[(i*8)+7 : i*8];
            
            // Speculative computation
            // Arithmetic operations
            assign pu_res[i][OP_ADD] = a_seg + b_seg;
            assign pu_res[i][OP_SUB] = a_seg - b_seg;
            
            // Logical operations
            assign pu_res[i][OP_AND] = a_seg & b_seg;
            assign pu_res[i][OP_OR]  = a_seg | b_seg;
            assign pu_res[i][OP_XOR] = a_seg ^ b_seg;
            assign pu_res[i][OP_NOR] = ~(a_seg | b_seg);
            
            // Comparison operations
            assign pu_res[i][OP_SLT] = ($signed(a_seg) < $signed(b_seg)) ? 8'h01 : 8'h00;
            assign pu_res[i][OP_SLTU] = (a_seg < b_seg) ? 8'h01 : 8'h00;
            
            // Shift operations (segment-specific)
            wire [4:0] shift_amt = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0];
            assign pu_res[i][OP_SLL] = (i == 3) ? b_seg << shift_amt : 8'h00;
            assign pu_res[i][OP_SRL] = (i == 0) ? b_seg >> shift_amt : 8'h00;
            assign pu_res[i][OP_SRA] = (i == 0) ? $signed(b_seg) >>> shift_amt : 8'h00;
            
            // LUI operation
            assign pu_res[i][OP_LUI] = (i == 1) ? b_seg : 8'h00;
            
            // Segment flags
            assign pu_zero[i] = (pu_res[i][OP_ADD] == 8'h00);
            assign pu_neg[i] = pu_res[i][OP_ADD][7];
            assign pu_carry[i] = (a_seg + b_seg) >> 8;
            assign pu_ovfl[i] = (a_seg[7] == b_seg[7]) && 
                               (pu_res[i][OP_ADD][7] != a_seg[7]);
        end
    endgenerate

    // Operation selection
    reg [3:0] op_sel;
    always @(*) begin
        case (aluc)
            ADD:  op_sel = OP_ADD;
            ADDU: op_sel = OP_ADD;
            SUB:  op_sel = OP_SUB;
            SUBU: op_sel = OP_SUB;
            AND:  op_sel = OP_AND;
            OR:   op_sel = OP_OR;
            XOR:  op_sel = OP_XOR;
            NOR:  op_sel = OP_NOR;
            SLT:  op_sel = OP_SLT;
            SLTU: op_sel = OP_SLTU;
            SLL:  op_sel = OP_SLL;
            SRL:  op_sel = OP_SRL;
            SRA:  op_sel = OP_SRA;
            LUI:  op_sel = OP_LUI;
            default: op_sel = OP_ADD;
        endcase
    end

    // Result assembly
    always @(*) begin
        r = {pu_res[3][op_sel], pu_res[2][op_sel], 
             pu_res[1][op_sel], pu_res[0][op_sel]};
        
        // Special handling for shift operations
        if (aluc == SLL || aluc == SRL || aluc == SRA) begin
            r = r << (8 * (3 - a[1:0])); // Barrel shift alignment
        end
    end

    // Flag generation
    assign zero = &pu_zero; // All segments zero
    assign negative = pu_neg[3]; // MSB segment
    assign carry = |pu_carry; // Any carry
    assign overflow = |pu_ovfl; // Any overflow
    
    // SLT/SLTU flag
    assign flag = (aluc == SLT || aluc == SLTU) ? 
                 pu_res[3][op_sel][0] : 1'b0;

endmodule