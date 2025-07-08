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

    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;

    reg [32:0] sum_ext;  // For carry detection in addition/subtraction
    reg signed [32:0] sum_ext_signed;

    // Zero flag - combinational
    assign zero = (r == 32'b0);

    always @(*) begin
        // Default outputs
        r = 32'bz;
        carry = 1'b0;
        negative = 1'b0;
        overflow = 1'b0;
        flag = 1'bz;

        case (aluc)
            ADD: begin
                sum_ext_signed = {a_signed[31], a_signed} + {b_signed[31], b_signed};
                r = sum_ext_signed[31:0];
                carry = (sum_ext_signed[32] != sum_ext_signed[31]); // carry out not typically used for signed add but can indicate overflow
                negative = r[31];
                // Overflow: when sign of a == sign of b and sign of result != sign of a
                overflow = (~(a_signed[31] ^ b_signed[31])) & (a_signed[31] ^ r[31]);
            end
            ADDU: begin
                sum_ext = {1'b0, a} + {1'b0, b};
                r = sum_ext[31:0];
                carry = sum_ext[32];
                negative = r[31];
                overflow = 1'b0;
            end
            SUB: begin
                sum_ext_signed = {a_signed[31], a_signed} - {b_signed[31], b_signed};
                r = sum_ext_signed[31:0];
                carry = (sum_ext_signed[32] != sum_ext_signed[31]); // carry flag for subtraction can represent borrow
                negative = r[31];
                // Overflow: when sign of a != sign of b and sign of result != sign of a
                overflow = (a_signed[31] ^ b_signed[31]) & (a_signed[31] ^ r[31]);
            end
            SUBU: begin
                sum_ext = {1'b0, a} - {1'b0, b};
                r = sum_ext[31:0];
                carry = sum_ext[32]; // In subtraction unsigned, carry=1 means no borrow, carry=0 means borrow
                negative = r[31];
                overflow = 1'b0;
            end
            AND: begin
                r = a & b;
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
            end
            OR: begin
                r = a | b;
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
            end
            XOR: begin
                r = a ^ b;
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
            end
            NOR: begin
                r = ~(a | b);
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
            end
            SLT: begin
                // Set flag according to signed comparison
                flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
                r = {31'b0, flag};
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
            end
            SLTU: begin
                // Set flag according to unsigned comparison
                flag = (a < b) ? 1'b1 : 1'b0;
                r = {31'b0, flag};
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
            end
            SLL: begin
                r = b << a[4:0];
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
            end
            SRL: begin
                r = b >> a[4:0];
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
            end
            SRA: begin
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
            end
            SLLV: begin
                r = b << (a[4:0]);
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
            end
            SRLV: begin
                r = b >> (a[4:0]);
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
            end
            SRAV: begin
                r = $signed(b) >>> (a[4:0]);
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
            end
            LUI: begin
                // Load upper immediate: b is ignored, a's lower 16 bits are zeroed and upper 16 bits are set from b[15:0]
                r = {b[15:0], 16'b0};
                carry = 1'b0;
                negative = r[31];
                overflow = 1'b0;
            end
            default: begin
                r = 32'bz;
                carry = 1'b0;
                negative = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
        endcase
    end

endmodule