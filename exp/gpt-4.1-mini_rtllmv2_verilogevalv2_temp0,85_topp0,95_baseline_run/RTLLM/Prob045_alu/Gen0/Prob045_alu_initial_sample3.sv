module alu (
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

// Internal signed versions for signed operations
wire signed [31:0] a_signed = a;
wire signed [31:0] b_signed = b;

// Intermediate sums and differences with carry and overflow detection
wire [32:0] sum_ext = {1'b0, a} + {1'b0, b};
wire [32:0] diff_ext = {1'b0, a} - {1'b0, b};
wire signed [32:0] sum_signed_ext = {a_signed[31], a_signed} + {b_signed[31], b_signed};
wire signed [32:0] diff_signed_ext = {a_signed[31], a_signed} - {b_signed[31], b_signed};

always @(*) begin
    // Default outputs
    r = 32'bz;
    carry = 1'b0;
    negative = 1'b0;
    overflow = 1'b0;
    flag = 1'bz;
    
    case (aluc)
        ADD: begin
            r = sum_ext[31:0];
            carry = sum_ext[32];
            // Overflow occurs if signs of a and b are same and sign of result differs
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            negative = r[31];
            flag = 1'bz;
        end
        ADDU: begin
            r = sum_ext[31:0];
            carry = sum_ext[32];
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        SUB: begin
            r = diff_ext[31:0];
            carry = ~diff_ext[32]; // borrow flag for subtraction as carry
            // Overflow detection for subtraction: signs of a and b differ and result sign differs from a
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            negative = r[31];
            flag = 1'bz;
        end
        SUBU: begin
            r = diff_ext[31:0];
            carry = ~diff_ext[32]; // borrow flag as carry for unsigned subtraction
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        AND: begin
            r = a & b;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        OR: begin
            r = a | b;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        XOR: begin
            r = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        NOR: begin
            r = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        SLT: begin
            // Set flag to 1 if a_signed < b_signed
            flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        SLTU: begin
            // Set flag to 1 if a < b unsigned
            flag = (a < b) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
        end
        SLL: begin
            r = b << a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        SRL: begin
            r = b >> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        SRA: begin
            r = $signed(b) >>> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        SLLV: begin
            r = b << a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        SRLV: begin
            r = b >> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        SRAV: begin
            r = $signed(b) >>> a[4:0];
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        LUI: begin
            // Load upper immediate: b is ignored, a's lower 16 bits are zeroed, upper 16 bits = b[15:0]
            // But description says upper 16 bits of a concatenated with 16 zeros
            // The usual LUI is b << 16, but here as per description:
            r = {a[15:0], 16'b0};
            carry = 1'b0;
            overflow = 1'b0;
            negative = r[31];
            flag = 1'bz;
        end
        default: begin
            r = 32'bz;
            carry = 1'b0;
            overflow = 1'b0;
            negative = 1'b0;
            flag = 1'bz;
        end
    endcase
end

assign zero = (r == 32'b0);

endmodule