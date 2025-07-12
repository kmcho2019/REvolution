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

wire [4:0] shamt = a[4:0];

// 33-bit wires for arithmetic results with carry out
wire [32:0] add_res  = {1'b0, a} + {1'b0, b};
wire [32:0] addu_res = {1'b0, a} + {1'b0, b};
wire [32:0] sub_res  = {1'b0, a} - {1'b0, b};
wire [32:0] subu_res = {1'b0, a} - {1'b0, b};

// Overflow detection for ADD and SUB (signed)
wire add_overflow = (~a[31] & ~b[31] & add_res[31]) | (a[31] & b[31] & ~add_res[31]);
wire sub_overflow = (a[31] & ~b[31] & ~sub_res[31]) | (~a[31] & b[31] & sub_res[31]);

// Result wires for each operation
wire [31:0] and_res  = a & b;
wire [31:0] or_res   = a | b;
wire [31:0] xor_res  = a ^ b;
wire [31:0] nor_res  = ~(a | b);
wire [31:0] slt_res  = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
wire [31:0] sltu_res = (a < b) ? 32'd1 : 32'd0;
wire [31:0] sll_res  = b << shamt;
wire [31:0] srl_res  = b >> shamt;
wire [31:0] sra_res  = $signed(b) >>> shamt;
wire [31:0] sllv_res = b << a[4:0];
wire [31:0] srlv_res = b >> a[4:0];
wire [31:0] srav_res = $signed(b) >>> a[4:0];
wire [31:0] lui_res  = {a[15:0], 16'b0};

// Select result based on aluc
reg [31:0] res_mux;
reg carry_mux;
reg overflow_mux;

always @(*) begin
    case (aluc)
        ADD: begin
            res_mux = add_res[31:0];
            carry_mux = add_res[32];
            overflow_mux = add_overflow;
        end
        ADDU: begin
            res_mux = addu_res[31:0];
            carry_mux = addu_res[32];
            overflow_mux = 1'b0;
        end
        SUB: begin
            res_mux = sub_res[31:0];
            carry_mux = sub_res[32];
            overflow_mux = sub_overflow;
        end
        SUBU: begin
            res_mux = subu_res[31:0];
            carry_mux = subu_res[32];
            overflow_mux = 1'b0;
        end
        AND: begin
            res_mux = and_res;
            carry_mux = 1'b0;
            overflow_mux = 1'b0;
        end
        OR: begin
            res_mux = or_res;
            carry_mux = 1'b0;
            overflow_mux = 1'b0;
        end
        XOR: begin
            res_mux = xor_res;
            carry_mux = 1'b0;
            overflow_mux = 1'b0;
        end
        NOR: begin
            res_mux = nor_res;
            carry_mux = 1'b0;
            overflow_mux = 1'b0;
        end
        SLT: begin
            res_mux = slt_res;
            carry_mux = 1'b0;
            overflow_mux = 1'b0;
        end
        SLTU: begin
            res_mux = sltu_res;
            carry_mux = 1'b0;
            overflow_mux = 1'b0;
        end
        SLL: begin
            res_mux = sll_res;
            carry_mux = 1'b0;
            overflow_mux = 1'b0;
        end
        SRL: begin
            res_mux = srl_res;
            carry_mux = 1'b0;
            overflow_mux = 1'b0;
        end
        SRA: begin
            res_mux = sra_res;
            carry_mux = 1'b0;
            overflow_mux = 1'b0;
        end
        SLLV: begin
            res_mux = sllv_res;
            carry_mux = 1'b0;
            overflow_mux = 1'b0;
        end
        SRLV: begin
            res_mux = srlv_res;
            carry_mux = 1'b0;
            overflow_mux = 1'b0;
        end
        SRAV: begin
            res_mux = srav_res;
            carry_mux = 1'b0;
            overflow_mux = 1'b0;
        end
        LUI: begin
            res_mux = lui_res;
            carry_mux = 1'b0;
            overflow_mux = 1'b0;
        end
        default: begin
            res_mux = 32'b0;
            carry_mux = 1'b0;
            overflow_mux = 1'b0;
        end
    endcase
end

assign r = res_mux;
assign carry = carry_mux;
assign overflow = overflow_mux;
assign negative = r[31];
assign zero = (r == 32'b0);
assign flag = (aluc == SLT || aluc == SLTU) ? r[0] : 1'bz;

endmodule