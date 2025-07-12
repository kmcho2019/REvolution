module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output reg         negative,
    output reg         overflow,
    output reg         flag
);

// Opcode parameters
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
wire signed [31:0] a_s = a;
wire signed [31:0] b_s = b;

// Extended operands for carry detection (33 bits)
wire [32:0] add_ext = {1'b0, a} + {1'b0, b};
wire [32:0] sub_ext = {1'b0, a} - {1'b0, b};

always @(*) begin
    // Default output assignments
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;
    negative = 1'b0;

    case (aluc)
        ADD: begin
            {carry, r} = add_ext;
            // Overflow: sign(a) == sign(b) && sign(r) != sign(a)
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
        end
        ADDU: begin
            {carry, r} = add_ext;
            overflow = 1'b0;
        end
        SUB: begin
            {carry, r} = sub_ext;
            // Overflow: sign(a) != sign(b) && sign(r) != sign(a)
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
        end
        SUBU: begin
            {carry, r} = sub_ext;
            overflow = 1'b0;
        end
        AND: r = a & b;
        OR:  r = a | b;
        XOR: r = a ^ b;
        NOR: r = ~(a | b);
        SLT: begin
            flag = (a_s < b_s);
            r = {31'b0, flag};
        end
        SLTU: begin
            flag = (a < b);
            r = {31'b0, flag};
        end
        SLL:  r = b << shamt;
        SRL:  r = b >> shamt;
        SRA:  r = b_s >>> shamt;
        SLLV: r = b << shamt;
        SRLV: r = b >> shamt;
        SRAV: r = b_s >>> shamt;
        LUI:  r = {a[15:0], 16'b0};
        default: begin
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase

    negative = r[31];
end

assign zero = (r == 32'b0);

endmodule