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

// Operation codes
localparam ADD  = 6'b100000;
localparam ADDU = 6'b100001;
localparam SUB  = 6'b100010;
localparam SUBU = 6'b100011;
localparam AND  = 6'b100100;
localparam OR   = 6'b100101;
localparam XOR  = 6'b100110;
localparam NOR  = 6'b100111;
localparam SLT  = 6'b101010;
localparam SLTU = 6'b101011;
localparam SLL  = 6'b000000;
localparam SRL  = 6'b000010;
localparam SRA  = 6'b000011;
localparam SLLV = 6'b000100;
localparam SRLV = 6'b000110;
localparam SRAV = 6'b000111;
localparam LUI  = 6'b001111;

// Signed inputs for arithmetic and comparisons
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);
wire [4:0] shamt = a[4:0];

reg [32:0] add_ext;
reg [32:0] sub_ext;

always @(*) begin
    // Default assignments
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;
    zero = 1'b0;
    negative = 1'b0;
    add_ext = 33'b0;
    sub_ext = 33'b0;

    case (aluc)
        ADD: begin
            add_ext = {1'b0, a} + {1'b0, b};
            r = add_ext[31:0];
            carry = add_ext[32];
            // Overflow for signed add
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
        end
        ADDU: begin
            add_ext = {1'b0, a} + {1'b0, b};
            r = add_ext[31:0];
            carry = add_ext[32];
            overflow = 1'b0;
        end
        SUB: begin
            sub_ext = {1'b0, a} - {1'b0, b};
            r = sub_ext[31:0];
            // For borrow in subtraction: carry is inverted borrow out (1 means no borrow)
            carry = sub_ext[32];
            // Overflow for signed subtract
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
        end
        SUBU: begin
            sub_ext = {1'b0, a} - {1'b0, b};
            r = sub_ext[31:0];
            carry = sub_ext[32];
            overflow = 1'b0;
        end
        AND: begin
            r = a & b;
        end
        OR: begin
            r = a | b;
        end
        XOR: begin
            r = a ^ b;
        end
        NOR: begin
            r = ~(a | b);
        end
        SLT: begin
            flag = (a_s < b_s) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
        end
        SLTU: begin
            flag = (a < b) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
        end
        SLL: begin
            r = b << shamt;
        end
        SRL: begin
            r = b >> shamt;
        end
        SRA: begin
            r = b_s >>> shamt;
        end
        SLLV: begin
            r = b << shamt;
        end
        SRLV: begin
            r = b >> shamt;
        end
        SRAV: begin
            r = b_s >>> shamt;
        end
        LUI: begin
            r = {a[15:0], 16'b0}; // Load upper immediate (lower 16 bits shifted left 16)
        end
        default: begin
            // When aluc is unrecognized, outputs remain zero
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'b0;
        end
    endcase

    zero = (r == 32'b0) ? 1'b1 : 1'b0;
    negative = r[31];
end

endmodule