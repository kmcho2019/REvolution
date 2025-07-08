module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [5:0]  aluc,
    output reg  [31:0] r,
    output wire        zero,
    output reg         carry,
    output wire        negative,
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

    wire [31:0] b_invert = ~b + 1;

    wire [32:0] add_result = {1'b0,a} + {1'b0,b};
    wire [32:0] addu_result = {1'b0,a} + {1'b0,b};
    wire [32:0] sub_result = {1'b0,a} + {1'b0,~b} + 1'b1;
    wire [32:0] subu_result = {1'b0,a} + {1'b0,~b} + 1'b1;

    // Helper to detect overflow for addition and subtraction (signed)
    function automatic logic overflow_add(input signed [31:0] x, input signed [31:0] y, input signed [31:0] res);
        begin
            // Overflow occurs if sign of x == sign of y, but sign of res != sign of x
            overflow_add = (~(x[31] ^ y[31])) & (x[31] ^ res[31]);
        end
    endfunction

    function automatic logic overflow_sub(input signed [31:0] x, input signed [31:0] y, input signed [31:0] res);
        begin
            // For subtraction x - y, overflow if sign of x != sign of y, and sign of res != sign of x
            overflow_sub = (x[31] ^ y[31]) & (x[31] ^ res[31]);
        end
    endfunction

    always @(*) begin
        // Defaults
        r = 32'bz;
        carry = 1'b0;
        overflow = 1'b0;
        flag = 1'bz;

        case (aluc)
            ADD: begin
                r = a + b;
                carry = ( {1'b0,a} + {1'b0,b} ) > 32'hFFFFFFFF;
                overflow = overflow_add(a_signed, b_signed, r);
                flag = 1'bz;
            end
            ADDU: begin
                r = a + b;
                carry = ( {1'b0,a} + {1'b0,b} ) > 32'hFFFFFFFF;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SUB: begin
                r = a - b;
                carry = (a < b) ? 1'b1 : 1'b0; // Borrow as carry for subtraction
                overflow = overflow_sub(a_signed, b_signed, r);
                flag = 1'bz;
            end
            SUBU: begin
                r = a - b;
                carry = (a < b) ? 1'b1 : 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            AND: begin
                r = a & b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            OR: begin
                r = a | b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            XOR: begin
                r = a ^ b;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            NOR: begin
                r = ~(a | b);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SLT: begin
                // Set flag for signed comparison a < b
                flag = (a_signed < b_signed) ? 1'b1 : 1'b0;
                r = {31'b0, flag};
                carry = 1'b0;
                overflow = 1'b0;
            end
            SLTU: begin
                // Set flag for unsigned comparison
                flag = (a < b) ? 1'b1 : 1'b0;
                r = {31'b0, flag};
                carry = 1'b0;
                overflow = 1'b0;
            end
            SLL: begin
                r = b << a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRL: begin
                r = b >> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRA: begin
                r = $signed(b) >>> a[4:0];
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SLLV: begin
                r = b << (a[4:0]);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRLV: begin
                r = b >> (a[4:0]);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            SRAV: begin
                r = $signed(b) >>> (a[4:0]);
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            LUI: begin
                r = {b[15:0], 16'b0};
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
            default: begin
                r = 32'bz;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'bz;
            end
        endcase
    end

    assign zero = (r == 32'b0) ? 1'b1 : 1'b0;
    assign negative = r[31];

endmodule