module alu(
    input clk,
    input rst_n,
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

    // One-hot encoded operation codes
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
    wire is_arith = (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU);
    wire is_shift = (aluc == SLL || aluc == SRL || aluc == SRA || 
                    aluc == SLLV || aluc == SRLV || aluc == SRAV);
    wire is_logic = (aluc == AND || aluc == OR || aluc == XOR || aluc == NOR);
    wire is_comp = (aluc == SLT || aluc == SLTU);
    wire is_lui = (aluc == LUI);

    // Pipelined arithmetic operations
    reg [32:0] add_result, sub_result;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            add_result <= 33'b0;
            sub_result <= 33'b0;
        end else if (is_arith) begin
            add_result <= {1'b0, a} + {1'b0, b};
            sub_result <= {1'b0, a} - {1'b0, b};
        end
    end

    // Shift operations (operand isolated)
    wire [4:0] shift_amount = (aluc[3] /* SxLV */) ? a[4:0] : b[4:0];
    reg [31:0] shift_result;
    always @(*) begin
        if (is_shift) begin
            case (aluc[2:0])
                3'b000: shift_result = b << shift_amount;  // SLL/SLLV
                3'b010: shift_result = b >> shift_amount;  // SRL/SRLV
                3'b011: shift_result = $signed(b) >>> shift_amount; // SRA/SRAV
                default: shift_result = 32'b0;
            endcase
        end
    end

    // Comparison operations
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    reg comp_result;
    always @(*) begin
        if (is_comp) begin
            comp_result = (aluc == SLT) ? (a_signed < b_signed) : (a < b);
        end
    end

    // Result selection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r <= 32'b0;
            {zero, carry, negative, overflow, flag} <= 5'b0;
        end else begin
            case (1'b1)
                is_arith: begin
                    case (aluc)
                        ADD, ADDU: r <= add_result[31:0];
                        SUB, SUBU: r <= sub_result[31:0];
                    endcase
                    carry <= (aluc == ADD || aluc == ADDU) ? add_result[32] : 
                            (aluc == SUB || aluc == SUBU) ? sub_result[32] : 1'b0;
                    overflow <= (aluc == ADD) ? (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]) :
                                (aluc == SUB) ? (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]) : 1'b0;
                end
                is_logic: begin
                    case (aluc)
                        AND: r <= a & b;
                        OR:  r <= a | b;
                        XOR: r <= a ^ b;
                        NOR: r <= ~(a | b);
                    endcase
                end
                is_shift: r <= shift_result;
                is_comp: begin
                    r <= {31'b0, comp_result};
                    flag <= comp_result;
                end
                is_lui: r <= {b[15:0], 16'b0};
                default: r <= 32'b0;
            endcase

            // Common flags
            zero <= (r == 32'b0);
            negative <= r[31];
        end
    end

endmodule