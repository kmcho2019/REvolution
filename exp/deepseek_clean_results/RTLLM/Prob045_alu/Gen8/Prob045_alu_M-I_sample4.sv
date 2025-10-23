module alu(
    input clk,          // Added for pipelining
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

    // Pipelined adder/subtractor
    reg [32:0] adder_stage1;
    reg [32:0] adder_result;
    always @(posedge clk) begin
        adder_stage1 <= {1'b0, a} + {1'b0, (aluc[0] ? ~b : b)};
        adder_result <= adder_stage1 + aluc[0];
    end

    // Shared barrel shifter
    wire [4:0] shift_amount = (aluc[2:0] == 3'b100) ? a[4:0] : b[4:0];
    wire [31:0] shifted_val;
    assign shifted_val = aluc[1] ? ($signed(b) >>> shift_amount) : 
                        (b << shift_amount);

    // Shared comparator for SLT/SLTU
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire comp_result = (aluc == SLTU) ? (a < b) : (a_signed < b_signed);

    // Operation enable signals
    wire is_arith = (aluc[5:3] == 3'b100);
    wire is_logic = (aluc[5:3] == 3'b100) && (aluc[2:0] >= 4 && (aluc[2:0] <= 7);
    wire is_shift = (aluc[5:3] == 3'b000);
    wire is_comp = (aluc == SLT) || (aluc == SLTU);

    always @(*) begin
        case (aluc)
            ADD, ADDU, SUB, SUBU: r = adder_result[31:0];
            AND:       r = a & b;
            OR:        r = a | b;
            XOR:       r = a ^ b;
            NOR:       r = ~(a | b);
            SLT, SLTU: begin r = 0; flag = comp_result; end
            LUI:       r = {b[15:0], 16'b0};
            SLL, SLLV, SRL, SRLV, SRA, SRAV: r = shifted_val;
            default:   r = 32'b0;
        endcase
    end

    // Optimized flag outputs
    assign zero = (r == 32'b0);
    assign carry = is_arith ? adder_result[32] : 1'b0;
    assign negative = r[31];
    assign overflow = is_arith & (adder_result[32] ^ adder_result[31]);

endmodule