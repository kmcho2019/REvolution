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

// Arithmetic operations (with carry out)
wire [32:0] add_res;
wire [32:0] sub_res;
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);
wire signed [31:0] r_s;

assign add_res = {1'b0, a} + {1'b0, b};
assign sub_res = {1'b0, a} - {1'b0, b};
assign r_s = $signed(r);

reg [31:0] arith_res;
reg arith_carry;
reg arith_overflow;

reg [31:0] logic_res;
reg [31:0] shift_res;
reg [31:0] setflag_res;

always @(*) begin
    // Default assignments
    arith_res = 32'b0;
    arith_carry = 1'b0;
    arith_overflow = 1'b0;
    logic_res = 32'b0;
    shift_res = 32'b0;
    setflag_res = 32'b0;
    flag = 1'b0;

    case (aluc)
        // Arithmetic
        ADD: begin
            arith_res = add_res[31:0];
            arith_carry = add_res[32];
            // Overflow detection for signed add:
            arith_overflow = (~a[31] & ~b[31] & arith_res[31]) | (a[31] & b[31] & ~arith_res[31]);
        end
        ADDU: begin
            arith_res = add_res[31:0];
            arith_carry = add_res[32];
            arith_overflow = 1'b0;
        end
        SUB: begin
            arith_res = sub_res[31:0];
            arith_carry = ~sub_res[32]; // Borrow flag (carry set if no borrow)
            // Overflow detection for signed sub:
            arith_overflow = (a[31] & ~b[31] & ~arith_res[31]) | (~a[31] & b[31] & arith_res[31]);
        end
        SUBU: begin
            arith_res = sub_res[31:0];
            arith_carry = ~sub_res[32];
            arith_overflow = 1'b0;
        end

        // Logical operations
        AND:  logic_res = a & b;
        OR:   logic_res = a | b;
        XOR:  logic_res = a ^ b;
        NOR:  logic_res = ~(a | b);

        // Set less than (flag and result)
        SLT: begin
            flag = (a_s < b_s);
            setflag_res = {31'b0, flag};
        end
        SLTU: begin
            flag = (a < b);
            setflag_res = {31'b0, flag};
        end

        // Shift operations
        SLL:  shift_res = b << shamt;
        SRL:  shift_res = b >> shamt;
        SRA:  shift_res = $signed(b) >>> shamt;
        SLLV: shift_res = b << a[4:0];
        SRLV: shift_res = b >> a[4:0];
        SRAV: shift_res = $signed(b) >>> a[4:0];

        // Load upper immediate
        LUI:  logic_res = {b[15:0], 16'b0};

        default: begin
            arith_res = 32'b0;
            arith_carry = 1'b0;
            arith_overflow = 1'b0;
            logic_res = 32'b0;
            shift_res = 32'b0;
            setflag_res = 32'b0;
            flag = 1'b0;
        end
    endcase
end

always @(*) begin
    // Output mux: prioritize in order: setflag -> arithmetic -> shift -> logic
    if (aluc == SLT || aluc == SLTU) begin
        r = setflag_res;
        carry = 1'b0;
        overflow = 1'b0;
    end
    else if (aluc == ADD || aluc == ADDU || aluc == SUB || aluc == SUBU) begin
        r = arith_res;
        carry = arith_carry;
        overflow = arith_overflow;
    end
    else if (aluc == SLL || aluc == SRL || aluc == SRA || aluc == SLLV || aluc == SRLV || aluc == SRAV) begin
        r = shift_res;
        carry = 1'b0;
        overflow = 1'b0;
    end
    else begin // Logical ops including LUI
        r = logic_res;
        carry = 1'b0;
        overflow = 1'b0;
    end

    negative = r[31];
    zero = (r == 32'b0);
end

endmodule