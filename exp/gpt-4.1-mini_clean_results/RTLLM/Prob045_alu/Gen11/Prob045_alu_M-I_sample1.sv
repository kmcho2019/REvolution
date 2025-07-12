module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output reg         zero,
    output reg         carry,
    output reg         negative,
    output reg         overflow,
    output reg         flag
);

// Define opcodes as parameters for clarity
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

wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);
wire [4:0] shamt = a[4:0];

reg [31:0] res;
reg       c_out;
reg       ovf;
reg       flg;

// Compute arithmetic results with carry out for ADD/SUB
reg [32:0] add_res;
reg [32:0] sub_res;

always @* begin
    // Default assignments for intermediate signals
    res = 32'b0;
    c_out = 1'b0;
    ovf = 1'b0;
    flg = 1'b0;

    case (aluc)
        ADD: begin
            add_res = {1'b0, a} + {1'b0, b};
            res = add_res[31:0];
            c_out = add_res[32];
            // Overflow detection for signed addition
            ovf = (~a[31] & ~b[31] & res[31]) | (a[31] & b[31] & ~res[31]);
        end
        ADDU: begin
            add_res = {1'b0, a} + {1'b0, b};
            res = add_res[31:0];
            c_out = add_res[32];
            // No overflow for unsigned add
            ovf = 1'b0;
        end
        SUB: begin
            sub_res = {1'b0, a} - {1'b0, b};
            res = sub_res[31:0];
            c_out = sub_res[32]; // borrow inverted
            // Overflow detection for signed subtraction
            ovf = (a[31] & ~b[31] & ~res[31]) | (~a[31] & b[31] & res[31]);
        end
        SUBU: begin
            sub_res = {1'b0, a} - {1'b0, b};
            res = sub_res[31:0];
            c_out = sub_res[32];
            ovf = 1'b0;
        end
        AND:   res = a & b;
        OR:    res = a | b;
        XOR:   res = a ^ b;
        NOR:   res = ~(a | b);
        SLT: begin
            flg = (a_s < b_s) ? 1'b1 : 1'b0;
            res = {31'b0, flg};
        end
        SLTU: begin
            flg = (a < b) ? 1'b1 : 1'b0;
            res = {31'b0, flg};
        end
        SLL:   res = b << shamt;
        SRL:   res = b >> shamt;
        SRA:   res = $signed(b_s) >>> shamt;
        SLLV:  res = b << a[4:0];
        SRLV:  res = b >> a[4:0];
        SRAV:  res = $signed(b_s) >>> a[4:0];
        LUI:   res = {b[15:0], 16'b0};  // Correct LUI: loads immediate in upper 16 bits, lower zero
        default: begin
            res = 32'b0;
            c_out = 1'b0;
            ovf = 1'b0;
            flg = 1'b0;
        end
    endcase

    // Assign outputs after computation to reduce glitches
    r = res;
    carry = c_out;
    overflow = ovf;
    zero = (res == 32'b0);
    negative = res[31];

    // According to problem, flag is set only for SLT or SLTU; otherwise, high impedance ('z')
    // For synthesis friendliness, assign 0 when not SLT/SLTU.
    if (aluc == SLT || aluc == SLTU)
        flag = flg;
    else
        flag = 1'bz; // Use high impedance as problem states
end

endmodule