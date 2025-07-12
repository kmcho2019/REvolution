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

// Operation codes
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
wire [4:0] shamt = (aluc == SLL || aluc == SRL || aluc == SRA) ? a[4:0] : a[4:0];

always @(*) begin
    // Default assignments
    r        <= 32'b0;
    carry    <= 1'b0;
    overflow <= 1'b0;
    flag     <= 1'b0;
    negative <= 1'b0;

    case (aluc)
        ADD: begin
            {carry, r} <= {1'b0, a} + {1'b0, b};
            overflow <= (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
        end
        ADDU: begin
            {carry, r} <= {1'b0, a} + {1'b0, b};
            overflow <= 1'b0;
        end
        SUB: begin
            {carry, r} <= {1'b0, a} - {1'b0, b};
            overflow <= (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
        end
        SUBU: begin
            {carry, r} <= {1'b0, a} - {1'b0, b};
            overflow <= 1'b0;
        end
        AND:    r <= a & b;
        OR:     r <= a | b;
        XOR:    r <= a ^ b;
        NOR:    r <= ~(a | b);
        SLT: begin
            r <= (a_s < b_s) ? 32'b1 : 32'b0;
            flag <= (a_s < b_s) ? 1'b1 : 1'b0;
        end
        SLTU: begin
            r <= (a < b) ? 32'b1 : 32'b0;
            flag <= (a < b) ? 1'b1 : 1'b0;
        end
        SLL:  r <= b << shamt;
        SRL:  r <= b >> shamt;
        SRA:  r <= $signed(b_s) >>> shamt;
        SLLV: r <= b << a[4:0];
        SRLV: r <= b >> a[4:0];
        SRAV: r <= $signed(b_s) >>> a[4:0];
        LUI:  r <= {a[15:0], 16'b0};
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