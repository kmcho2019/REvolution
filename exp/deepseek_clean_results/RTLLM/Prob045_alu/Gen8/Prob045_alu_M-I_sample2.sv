module alu(
    input clk,          // Added for pipelining
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

    // Shared arithmetic units
    wire [32:0] add_full = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_full = {1'b0, a} - {1'b0, b};
    
    // Shift amount selection
    wire [4:0] shift_amount = 
        (aluc == SLLV || aluc == SRLV || aluc == SRAV) ? a[4:0] : b[4:0];
    
    // Logarithmic barrel shifter
    wire [31:0] shift_res;
    barrel_shifter shifter(
        .in(b),
        .shift(shift_amount),
        .mode(aluc[1:0]), // SLL=00, SRL=10, SRA=11
        .out(shift_res)
    );

    // Operation selection
    always @(posedge clk) begin
        case(aluc)
            ADD, ADDU:  r <= add_full[31:0];
            SUB, SUBU:  r <= sub_full[31:0];
            AND:        r <= a & b;
            OR:         r <= a | b;
            XOR:        r <= a ^ b;
            NOR:        r <= ~(a | b);
            SLT:        r <= {31'b0, $signed(a) < $signed(b)};
            SLTU:       r <= {31'b0, a < b};
            SLL, SRL, SRA, SLLV, SRLV, SRAV: r <= shift_res;
            LUI:        r <= {b[15:0], 16'b0};
            default:    r <= 32'b0;
        endcase
    end

    // Flag computation (pipelined)
    always @(posedge clk) begin
        // Common flags
        zero <= (r == 0);
        negative <= r[31];
        
        // Operation-specific flags
        case(aluc)
            ADD: begin
                carry <= add_full[32];
                overflow <= (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            end
            ADDU: carry <= add_full[32];
            SUB: begin
                carry <= sub_full[32];
                overflow <= (~a[31] & b[31] & r[31]) | (a[31] & ~b[31] & ~r[31]);
            end
            SUBU: carry <= sub_full[32];
            SLT: flag <= $signed(a) < $signed(b);
            SLTU: flag <= a < b;
            default: begin
                carry <= 1'b0;
                overflow <= 1'b0;
                flag <= 1'b0;
            end
        endcase
    end

endmodule

// Optimized logarithmic barrel shifter
module barrel_shifter(
    input [31:0] in,
    input [4:0] shift,
    input [1:0] mode, // 00=SLL, 10=SRL, 11=SRA
    output reg [31:0] out
);
    wire [31:0] stage0 = shift[0] ? 
        (mode[1] ? {{1{in[31] & mode[0]}}, in[31:1]} : {in[30:0], 1'b0}) : in;
    wire [31:0] stage1 = shift[1] ? 
        (mode[1] ? {{2{stage0[31] & mode[0]}}, stage0[31:2]} : {stage0[29:0], 2'b0}) : stage0;
    wire [31:0] stage2 = shift[2] ? 
        (mode[1] ? {{4{stage1[31] & mode[0]}}, stage1[31:4]} : {stage1[27:0], 4'b0}) : stage1;
    wire [31:0] stage3 = shift[3] ? 
        (mode[1] ? {{8{stage2[31] & mode[0]}}, stage2[31:8]} : {stage2[23:0], 8'b0}) : stage2;
    wire [31:0] stage4 = shift[4] ? 
        (mode[1] ? {{16{stage3[31] & mode[0]}}, stage3[31:16]} : {stage3[15:0], 16'b0}) : stage3;
    
    always @(*) out = stage4;
endmodule