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

// Arithmetic operations with carry and overflow
wire [32:0] add_res = {1'b0,a} + {1'b0,b};
wire [32:0] sub_res = {1'b0,a} - {1'b0,b};

// Carry signals for add/sub (carry out = MSB of 33-bit result)
wire carry_add  = add_res[32];
wire carry_sub  = sub_res[32];

// Overflow detection for signed add/sub
wire overflow_add = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
wire overflow_sub = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

// Logical operations
wire [31:0] and_res = a & b;
wire [31:0] or_res  = a | b;
wire [31:0] xor_res = a ^ b;
wire [31:0] nor_res = ~(a | b);

// Shift operations
wire [31:0] sll_res  = b << shamt;
wire [31:0] srl_res  = b >> shamt;
wire [31:0] sra_res  = $signed(b) >>> shamt;
wire [31:0] sllv_res = b << a[4:0];
wire [31:0] srlv_res = b >> a[4:0];
wire [31:0] srav_res = $signed(b) >>> a[4:0];

// SLT and SLTU results and flags
wire slt_flag  = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0;
wire sltu_flag = (a < b) ? 1'b1 : 1'b0;
wire [31:0] slt_res  = {31'b0, slt_flag};
wire [31:0] sltu_res = {31'b0, sltu_flag};

// LUI operation: upper 16 bits of a concatenated with 16 zeros
wire [31:0] lui_res = {a[15:0], 16'b0};

// Result multiplexer based on aluc
reg [31:0] r_mux;
reg       carry_mux;
reg       overflow_mux;
reg       flag_mux;

always @(*) begin
    r_mux = 32'b0;
    carry_mux = 1'b0;
    overflow_mux = 1'b0;
    flag_mux = 1'bz; // default high impedance for flag except SLT, SLTU
    case (aluc)
        ADD: begin
            r_mux = add_res[31:0];
            carry_mux = carry_add;
            overflow_mux = overflow_add;
            flag_mux = 1'b0;
        end
        ADDU: begin
            r_mux = add_res[31:0];
            carry_mux = carry_add;
            overflow_mux = 1'b0;
            flag_mux = 1'b0;
        end
        SUB: begin
            r_mux = sub_res[31:0];
            carry_mux = carry_sub;
            overflow_mux = overflow_sub;
            flag_mux = 1'b0;
        end
        SUBU: begin
            r_mux = sub_res[31:0];
            carry_mux = carry_sub;
            overflow_mux = 1'b0;
            flag_mux = 1'b0;
        end
        AND: begin
            r_mux = and_res;
            flag_mux = 1'b0;
        end
        OR: begin
            r_mux = or_res;
            flag_mux = 1'b0;
        end
        XOR: begin
            r_mux = xor_res;
            flag_mux = 1'b0;
        end
        NOR: begin
            r_mux = nor_res;
            flag_mux = 1'b0;
        end
        SLT: begin
            r_mux = slt_res;
            flag_mux = slt_flag;
        end
        SLTU: begin
            r_mux = sltu_res;
            flag_mux = sltu_flag;
        end
        SLL: begin
            r_mux = sll_res;
            flag_mux = 1'b0;
        end
        SRL: begin
            r_mux = srl_res;
            flag_mux = 1'b0;
        end
        SRA: begin
            r_mux = sra_res;
            flag_mux = 1'b0;
        end
        SLLV: begin
            r_mux = sllv_res;
            flag_mux = 1'b0;
        end
        SRLV: begin
            r_mux = srlv_res;
            flag_mux = 1'b0;
        end
        SRAV: begin
            r_mux = srav_res;
            flag_mux = 1'b0;
        end
        LUI: begin
            r_mux = lui_res;
            flag_mux = 1'b0;
        end
        default: begin
            r_mux = 32'bz;  // high impedance for undefined opcode
            flag_mux = 1'bz;
        end
    endcase
end

assign r = r_mux;
assign zero = (r == 32'b0);
assign negative = r[31];
assign carry = carry_mux;
assign overflow = overflow_mux;
assign flag = flag_mux;

endmodule