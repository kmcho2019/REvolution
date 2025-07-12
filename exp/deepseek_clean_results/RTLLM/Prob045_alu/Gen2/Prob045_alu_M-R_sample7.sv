module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow,
    output reg flag
);

    // Operation codes as localparam
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

    // Internal signals
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    wire [4:0] shamt = b[4:0];
    wire [32:0] add_res = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_res = {1'b0, a} - {1'b0, b};

    always_comb begin
        // Default outputs
        r = 32'b0;
        flag = 1'bz;
        carry = 1'b0;
        overflow = 1'b0;

        case (aluc)
            ADD, ADDU: begin
                r = add_res[31:0];
                carry = add_res[32];
                if (aluc == ADD) begin
                    overflow = (a_signed[31] == b_signed[31]) && 
                              (r[31] != a_signed[31]);
                end
            end
            SUB, SUBU: begin
                r = sub_res[31:0];
                carry = sub_res[32];
                if (aluc == SUB) begin
                    overflow = (a_signed[31] != b_signed[31]) && 
                              (r[31] != a_signed[31]);
                end
            end
            AND: r = a & b;
            OR:  r = a | b;
            XOR: r = a ^ b;
            NOR: r = ~(a | b);
            SLT: begin
                r = {31'b0, a_signed < b_signed};
                flag = a_signed < b_signed;
            end
            SLTU: begin
                r = {31'b0, a < b};
                flag = a < b;
            end
            SLL: r = b << a[4:0];
            SRL: r = b >> a[4:0];
            SRA: r = $signed(b) >>> a[4:0];
            SLLV: r = b << shamt;
            SRLV: r = b >> shamt;
            SRAV: r = $signed(b) >>> shamt;
            LUI: r = {b[15:0], 16'b0};
            default: r = 32'bz;
        endcase

        // Common flag calculations
        zero = (r == 32'b0);
        negative = r[31];
    end

endmodule