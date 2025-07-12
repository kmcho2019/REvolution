module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output wire [31:0] r,
    output wire        zero,
    output wire        carry,
    output wire        negative,
    output wire        overflow,
    output wire        flag
);

// Opcodes as parameters
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

wire [4:0] shamt = a[4:0];

// Intermediate extended operands for arithmetic
wire [32:0] add_ext  = {1'b0, a} + {1'b0, b};
wire [32:0] addu_ext = {1'b0, a} + {1'b0, b};
wire [32:0] sub_ext  = {1'b0, a} - {1'b0, b};
wire [32:0] subu_ext = {1'b0, a} - {1'b0, b};

reg [31:0] r_reg;
reg carry_reg;
reg overflow_reg;
reg flag_reg;

// Compute result combinationally in a function-like manner using always_comb block for r_reg
always @(*) begin
    case(aluc)
        ADD:  r_reg = add_ext[31:0];
        ADDU: r_reg = addu_ext[31:0];
        SUB:  r_reg = sub_ext[31:0];
        SUBU: r_reg = subu_ext[31:0];
        AND:  r_reg = a & b;
        OR:   r_reg = a | b;
        XOR:  r_reg = a ^ b;
        NOR:  r_reg = ~(a | b);
        SLT:  r_reg = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
        SLTU: r_reg = (a < b) ? 32'd1 : 32'd0;
        SLL:  r_reg = b << shamt;
        SRL:  r_reg = b >> shamt;
        SRA:  r_reg = $signed(b) >>> shamt;
        SLLV: r_reg = b << a[4:0];
        SRLV: r_reg = b >> a[4:0];
        SRAV: r_reg = $signed(b) >>> a[4:0];
        LUI:  r_reg = {a[15:0],16'b0};
        default: r_reg = 32'bz;  // high impedance as per spec
    endcase
end

assign r = r_reg;

// Carry flag assigned only for ADD, ADDU, SUB, SUBU; else 0
assign carry = (aluc == ADD)  ? add_ext[32]  :
               (aluc == ADDU) ? addu_ext[32] :
               (aluc == SUB)  ? sub_ext[32]  :
               (aluc == SUBU) ? subu_ext[32] :
               1'b0;

// Overflow detection only for signed ADD and SUB
assign overflow = (aluc == ADD) ?
                    ((~a[31] & ~b[31] & r_reg[31]) | (a[31] & b[31] & ~r_reg[31])) :
                  (aluc == SUB) ?
                    ((a[31] & ~b[31] & ~r_reg[31]) | (~a[31] & b[31] & r_reg[31])) :
                  1'b0;

// Negative flag is MSB of result
assign negative = r_reg[31];

// Zero flag is asserted when result is zero
assign zero = (r_reg == 32'b0);

// Flag output set for SLT and SLTU, high impedance otherwise
assign flag = (aluc == SLT)  ? r_reg[0] :
              (aluc == SLTU) ? r_reg[0] :
                              1'bz;

endmodule