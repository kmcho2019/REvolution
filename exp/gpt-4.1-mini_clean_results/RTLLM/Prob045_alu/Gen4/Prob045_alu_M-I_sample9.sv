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

wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

wire [4:0] shamt = a[4:0] & 5'h1F;  // Mask shift amount for safety

// Intermediate variables for addition and subtraction results and carry out
reg [32:0] add_result;
reg [32:0] sub_result;

always @(*) begin
    // Default assignments
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'b0;
    negative = 1'b0;

    case (aluc)
        ADD: begin
            add_result = {1'b0, a} + {1'b0, b};
            r <= add_result[31:0];
            carry <= add_result[32];
            // Overflow occurs if the sign of inputs are same but sign of result differs
            overflow <= (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
        end
        ADDU: begin
            add_result = {1'b0, a} + {1'b0, b};
            r <= add_result[31:0];
            carry <= add_result[32];
            overflow <= 1'b0;
        end
        SUB: begin
            sub_result = {1'b0, a} - {1'b0, b};
            r <= sub_result[31:0];
            carry <= sub_result[32];
            // Overflow occurs if sign of inputs differ and sign of result differs from a
            overflow <= (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
        end
        SUBU: begin
            sub_result = {1'b0, a} - {1'b0, b};
            r <= sub_result[31:0];
            carry <= sub_result[32];
            overflow <= 1'b0;
        end
        AND: begin
            r <= a & b;
            carry <= 1'b0;
            overflow <= 1'b0;
        end
        OR: begin
            r <= a | b;
            carry <= 1'b0;
            overflow <= 1'b0;
        end
        XOR: begin
            r <= a ^ b;
            carry <= 1'b0;
            overflow <= 1'b0;
        end
        NOR: begin
            r <= ~(a | b);
            carry <= 1'b0;
            overflow <= 1'b0;
        end
        SLT: begin
            r <= (a_s < b_s) ? 32'd1 : 32'd0;
            flag <= (a_s < b_s) ? 1'b1 : 1'b0;
            carry <= 1'b0;
            overflow <= 1'b0;
        end
        SLTU: begin
            r <= (a < b) ? 32'd1 : 32'd0;
            flag <= (a < b) ? 1'b1 : 1'b0;
            carry <= 1'b0;
            overflow <= 1'b0;
        end
        SLL: begin
            r <= b << shamt;
            carry <= 1'b0;
            overflow <= 1'b0;
        end
        SRL: begin
            r <= b >> shamt;
            carry <= 1'b0;
            overflow <= 1'b0;
        end
        SRA: begin
            r <= b_s >>> shamt;
            carry <= 1'b0;
            overflow <= 1'b0;
        end
        SLLV: begin
            r <= b << (a[4:0] & 5'h1F);
            carry <= 1'b0;
            overflow <= 1'b0;
        end
        SRLV: begin
            r <= b >> (a[4:0] & 5'h1F);
            carry <= 1'b0;
            overflow <= 1'b0;
        end
        SRAV: begin
            r <= b_s >>> (a[4:0] & 5'h1F);
            carry <= 1'b0;
            overflow <= 1'b0;
        end
        LUI: begin
            r <= {a[15:0], 16'b0};
            carry <= 1'b0;
            overflow <= 1'b0;
        end
        default: begin
            r <= 32'b0;
            carry <= 1'b0;
            overflow <= 1'b0;
            flag <= 1'b0;
        end
    endcase

    negative <= r[31];
end

assign zero = (r == 32'b0);

endmodule