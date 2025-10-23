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

// Signed versions for arithmetic comparisons
wire signed [31:0] a_s = $signed(a);
wire signed [31:0] b_s = $signed(b);

// Shift amount extracted from a[4:0]
wire [4:0] shamt = a[4:0];

// Arithmetic operation intermediates
reg [32:0] addu_res; // 33 bits for carry detection
reg [32:0] adduu_res;
reg [32:0] sub_res;
reg [32:0] subu_res;

// Arithmetic results and flags
reg [31:0] arith_r;
reg        arith_carry;
reg        arith_overflow;
reg        arith_valid;  // flag to indicate arithmetic operation matched

// Logical operation result and valid flag
reg [31:0] logic_r;
reg        logic_valid;

// Shift operation result and valid flag
reg [31:0] shift_r;
reg        shift_valid;

// Flag from SLT and SLTU operations
reg slt_flag;
reg sltu_flag;

always @* begin
    // Default values
    arith_r        = 32'd0;
    arith_carry    = 1'b0;
    arith_overflow = 1'b0;
    arith_valid    = 1'b0;

    logic_r        = 32'd0;
    logic_valid    = 1'b0;

    shift_r        = 32'd0;
    shift_valid    = 1'b0;

    slt_flag       = 1'b0;
    sltu_flag      = 1'b0;

    // Arithmetic operations
    case (aluc)
        ADD: begin
            addu_res = {1'b0, a} + {1'b0, b};
            arith_r = addu_res[31:0];
            arith_carry = addu_res[32];
            // Overflow: when adding two operands with same sign results in different sign
            arith_overflow = (~a[31] & ~b[31] & arith_r[31]) | (a[31] & b[31] & ~arith_r[31]);
            arith_valid = 1'b1;
        end
        ADDU: begin
            adduu_res = {1'b0, a} + {1'b0, b};
            arith_r = adduu_res[31:0];
            arith_carry = adduu_res[32];
            arith_overflow = 1'b0;
            arith_valid = 1'b1;
        end
        SUB: begin
            sub_res = {1'b0, a} - {1'b0, b};
            arith_r = sub_res[31:0];
            arith_carry = sub_res[32]; // borrow: for subtraction carry=1 means no borrow, 0 means borrow occurred
            // Overflow for subtraction: signs of operands differ and sign of result differs from sign of a
            arith_overflow = (a[31] & ~b[31] & ~arith_r[31]) | (~a[31] & b[31] & arith_r[31]);
            arith_valid = 1'b1;
        end
        SUBU: begin
            subu_res = {1'b0, a} - {1'b0, b};
            arith_r = subu_res[31:0];
            arith_carry = subu_res[32];
            arith_overflow = 1'b0;
            arith_valid = 1'b1;
        end
        default: begin
            arith_r = 32'd0;
            arith_carry = 1'b0;
            arith_overflow = 1'b0;
            arith_valid = 1'b0;
        end
    endcase

    // Logical operations
    case (aluc)
        AND: begin
            logic_r = a & b;
            logic_valid = 1'b1;
        end
        OR: begin
            logic_r = a | b;
            logic_valid = 1'b1;
        end
        XOR: begin
            logic_r = a ^ b;
            logic_valid = 1'b1;
        end
        NOR: begin
            logic_r = ~(a | b);
            logic_valid = 1'b1;
        end
        default: begin
            logic_r = 32'd0;
            logic_valid = 1'b0;
        end
    endcase

    // Shift operations
    case (aluc)
        SLL: begin
            shift_r = b << shamt;
            shift_valid = 1'b1;
        end
        SRL: begin
            shift_r = b >> shamt;
            shift_valid = 1'b1;
        end
        SRA: begin
            shift_r = $signed(b_s) >>> shamt;
            shift_valid = 1'b1;
        end
        SLLV: begin
            shift_r = b << a[4:0];
            shift_valid = 1'b1;
        end
        SRLV: begin
            shift_r = b >> a[4:0];
            shift_valid = 1'b1;
        end
        SRAV: begin
            shift_r = $signed(b_s) >>> a[4:0];
            shift_valid = 1'b1;
        end
        default: begin
            shift_r = 32'd0;
            shift_valid = 1'b0;
        end
    endcase

    // Set flags for SLT and SLTU, and also prepare result for them
    case (aluc)
        SLT: begin
            slt_flag = (a_s < b_s) ? 1'b1 : 1'b0;
        end
        SLTU: begin
            sltu_flag = (a < b) ? 1'b1 : 1'b0;
        end
        default: begin
            slt_flag = 1'b0;
            sltu_flag = 1'b0;
        end
    endcase

    // LUI operation: concatenate a[15:0] as upper 16 bits, lower 16 bits zeroed
    // Note: According to original spec, "upper 16 bits of 'a' concatenated with 16 zeros"
    // means {a[31:16], 16'b0}
    if (aluc == LUI) begin
        r = {a[15:0], 16'b0};  // Using lower 16 bits of a as in example1, but spec says upper 16 bits; choose upper 16 bits for correctness
        // Corrected to upper 16 bits
        r = {a[31:16], 16'b0};
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
        zero = (r == 32'b0);
        negative = r[31];
        return;
    end

    // Final output mux logic: prioritize arithmetic, then logic, then shift, then SLT/SLTU flags
    if (arith_valid) begin
        r = arith_r;
        carry = arith_carry;
        overflow = arith_overflow;
        flag = 1'b0;
    end
    else if (logic_valid) begin
        r = logic_r;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
    end
    else if (shift_valid) begin
        r = shift_r;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
    end
    else if (aluc == SLT) begin
        r = {31'd0, slt_flag};
        carry = 1'b0;
        overflow = 1'b0;
        flag = slt_flag;
    end
    else if (aluc == SLTU) begin
        r = {31'd0, sltu_flag};
        carry = 1'b0;
        overflow = 1'b0;
        flag = sltu_flag;
    end
    else begin
        r = 32'd0;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;
    end

    zero = (r == 32'd0);
    negative = r[31];
end

endmodule