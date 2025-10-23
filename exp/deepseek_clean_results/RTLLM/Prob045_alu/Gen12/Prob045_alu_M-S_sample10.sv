module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output reg [31:0] r,
    output zero,
    output reg carry,
    output negative,
    output reg overflow,
    output reg flag
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

    // Internal signals
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    wire [4:0] shift_amt = aluc[3] ? a[4:0] : b[4:0];
    wire [32:0] add_result = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_result = {1'b0, a} - {1'b0, b};

    always @(*) begin
        // Default outputs
        r = 32'b0;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'b0;

        case (aluc)
            ADD: begin
                r = a + b;
                carry = add_result[32];
                overflow = (a[31] == b[31]) && (r[31] != a[31]);
            end
            ADDU: begin
                r = a + b;
                carry = add_result[32];
            end
            SUB: begin
                r = a - b;
                carry = sub_result[32];
                overflow = (a[31] != b[31]) && (r[31] != a[31]);
            end
            SUBU: begin
                r = a - b;
                carry = sub_result[32];
            end
            AND:  r = a & b;
            OR:   r = a | b;
            XOR:  r = a ^ b;
            NOR:  r = ~(a | b);
            SLT:  begin
                r = signed_a < signed_b;
                flag = r[0];
            end
            SLTU: begin
                r = a < b;
                flag = r[0];
            end
            SLL:  r = b << shift_amt;
            SRL:  r = b >> shift_amt;
            SRA:  r = signed_b >>> shift_amt;
            SLLV: r = b << a[4:0];
            SRLV: r = b >> a[4:0];
            SRAV: r = signed_b >>> a[4:0];
            LUI:  r = {b[15:0], 16'b0};
            default: r = 32'b0;
        endcase
    end

    assign zero = (r == 32'b0);
    assign negative = r[31];

endmodule