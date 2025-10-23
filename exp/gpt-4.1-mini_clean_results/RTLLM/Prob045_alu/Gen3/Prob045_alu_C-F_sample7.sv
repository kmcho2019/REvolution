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

// Signed versions of inputs
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shift amount from a[4:0]
wire [4:0] shamt = a[4:0];

// Extended operands for addition and subtraction (for carry and overflow)
wire [32:0] add_ext = {1'b0, a} + {1'b0, b};
wire [32:0] add_s_ext = {a[31], a} + {b[31], b};
wire [32:0] sub_ext = {1'b0, a} - {1'b0, b};
wire [32:0] sub_s_ext = {a[31], a} - {b[31], b};

always @(*) begin
    // Defaults
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'bz;  // high-impedance as per problem statement
    negative = 1'b0;

    case (aluc)
        ADD: begin
            {carry, r} = add_ext;
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            flag = 1'b0;
        end
        ADDU: begin
            {carry, r} = add_ext;
            overflow = 1'b0;
            flag = 1'b0;
        end
        SUB: begin
            {carry, r} = sub_ext;
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            flag = 1'b0;
        end
        SUBU: begin
            {carry, r} = sub_ext;
            overflow = 1'b0;
            flag = 1'b0;
        end
        AND: begin
            r = a & b;
            flag = 1'b0;
        end
        OR: begin
            r = a | b;
            flag = 1'b0;
        end
        XOR: begin
            r = a ^ b;
            flag = 1'b0;
        end
        NOR: begin
            r = ~(a | b);
            flag = 1'b0;
        end
        SLT: begin
            r = (a_s < b_s) ? 32'd1 : 32'd0;
            flag = (a_s < b_s) ? 1'b1 : 1'b0;
        end
        SLTU: begin
            r = (a < b) ? 32'd1 : 32'd0;
            flag = (a < b) ? 1'b1 : 1'b0;
        end
        SLL: begin
            r = b << shamt;
            flag = 1'b0;
        end
        SRL: begin
            r = b >> shamt;
            flag = 1'b0;
        end
        SRA: begin
            r = b_s >>> shamt;
            flag = 1'b0;
        end
        SLLV: begin
            r = b << a[4:0];
            flag = 1'b0;
        end
        SRLV: begin
            r = b >> a[4:0];
            flag = 1'b0;
        end
        SRAV: begin
            r = b_s >>> a[4:0];
            flag = 1'b0;
        end
        LUI: begin
            // According to problem statement: "upper 16 bits of 'a' concatenated with 16 zeros"
            r = {a[31:16], 16'b0};
            flag = 1'b0;
        end
        default: begin
            r = 32'bz; // high-impedance for undefined ops
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;
        end
    endcase

    negative = r[31];
end

assign zero = (r == 32'b0);

endmodule