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

    wire [4:0] shamt = a[4:0]; // unified shift amount

    reg [32:0] ext_result; // extended for carry detection

    always @(*) begin
        // Default assignments
        r = 32'b0;
        carry = 1'b0;
        overflow = 1'b0;
        negative = 1'b0;
        flag = 1'b0;

        case(aluc)
            // Signed addition
            ADD: begin
                ext_result = {1'b0, a} + {1'b0, b};
                r = ext_result[31:0];
                carry = ext_result[32];
                // Overflow for signed add: if sign of a and b are same but sign of result differs
                overflow = (~a[31] & ~b[31] & r[31]) | (a[31] & b[31] & ~r[31]);
            end
            // Unsigned addition
            ADDU: begin
                ext_result = {1'b0, a} + {1'b0, b};
                r = ext_result[31:0];
                carry = ext_result[32];
                overflow = 1'b0; // no overflow for unsigned add
            end
            // Signed subtraction
            SUB: begin
                ext_result = {1'b0, a} - {1'b0, b};
                r = ext_result[31:0];
                carry = ext_result[32]; // borrow in subtraction can be viewed as carry from MSB
                // Overflow for signed sub: if signs differ and sign of result differs from a
                overflow = (a[31] & ~b[31] & ~r[31]) | (~a[31] & b[31] & r[31]);
            end
            // Unsigned subtraction
            SUBU: begin
                ext_result = {1'b0, a} - {1'b0, b};
                r = ext_result[31:0];
                carry = ext_result[32];
                overflow = 1'b0;
            end
            // Logical AND
            AND: begin
                r = a & b;
            end
            // Logical OR
            OR: begin
                r = a | b;
            end
            // Logical XOR
            XOR: begin
                r = a ^ b;
            end
            // Logical NOR
            NOR: begin
                r = ~(a | b);
            end
            // Set less than (signed)
            SLT: begin
                flag = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0;
                r = flag ? 32'd1 : 32'd0;
            end
            // Set less than (unsigned)
            SLTU: begin
                flag = (a < b) ? 1'b1 : 1'b0;
                r = flag ? 32'd1 : 32'd0;
            end
            // Shift left logical
            SLL: begin
                r = b << shamt;
            end
            // Shift right logical
            SRL: begin
                r = b >> shamt;
            end
            // Shift right arithmetic
            SRA: begin
                r = $signed(b) >>> shamt;
            end
            // Variable shift left logical
            SLLV: begin
                r = b << shamt;
            end
            // Variable shift right logical
            SRLV: begin
                r = b >> shamt;
            end
            // Variable shift right arithmetic
            SRAV: begin
                r = $signed(b) >>> shamt;
            end
            // Load upper immediate
            LUI: begin
                r = {b[15:0], 16'b0}; // Use b as immediate source per MIPS spec
            end
            // Default case: output zero
            default: begin
                r = 32'b0;
                carry = 1'b0;
                overflow = 1'b0;
                flag = 1'b0;
            end
        endcase

        negative = r[31];
    end

    assign zero = (r == 32'b0);

endmodule