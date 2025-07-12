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

wire [4:0] shamt_a = a[4:0];
wire [4:0] shamt_b = b[4:0];

// Intermediate 33-bit for carry detection
reg [32:0] add_result;
reg [32:0] sub_result;

always @(*) begin
    // Default values
    r = 32'b0;
    carry = 1'b0;
    overflow = 1'b0;
    flag = 1'bz;    // High impedance when not SLT or SLTU
    negative = 1'b0;

    case(aluc)
        ADD: begin
            add_result = {1'b0, a} + {1'b0, b};
            r = add_result[31:0];
            carry = add_result[32];
            // Overflow if signs of a and b are same but differ from result
            overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
        end
        ADDU: begin
            add_result = {1'b0, a} + {1'b0, b};
            r = add_result[31:0];
            carry = add_result[32];
            overflow = 1'b0;
        end
        SUB: begin
            sub_result = {1'b0, a} - {1'b0, b};
            r = sub_result[31:0];
            carry = sub_result[32]; // borrow = ~carry for subtraction in MIPS convention
            // Overflow if signs of a and b differ and result sign differs from a
            overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
        end
        SUBU: begin
            sub_result = {1'b0, a} - {1'b0, b};
            r = sub_result[31:0];
            carry = sub_result[32];
            overflow = 1'b0;
        end
        AND:   r = a & b;
        OR:    r = a | b;
        XOR:   r = a ^ b;
        NOR:   r = ~(a | b);
        SLT: begin
            flag = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
        end
        SLTU: begin
            flag = (a < b) ? 1'b1 : 1'b0;
            r = {31'b0, flag};
        end
        SLL:   r = b << shamt_a;     // Shift amount from a[4:0]
        SRL:   r = b >> shamt_a;
        SRA:   r = $signed(b) >>> shamt_a;
        SLLV:  r = b << shamt_a;
        SRLV:  r = b >> shamt_a;
        SRAV:  r = $signed(b) >>> shamt_a;
        LUI:   r = {b[15:0], 16'b0}; // Correct LUI behavior: load immediate b into upper 16 bits
        default: begin
            r = 32'b0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = 1'bz;  // 'z' for unused flag per problem statement
        end
    endcase

    negative = r[31];
end

assign zero = (r == 32'b0);

endmodule