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

parameter ADD = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB = 6'b100010;
parameter SUBU = 6'b100011;
parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;
parameter SLT = 6'b101010;
parameter SLTU = 6'b101011;
parameter SLL = 6'b000000;
parameter SRL = 6'b000010;
parameter SRA = 6'b000011;
parameter SLLV = 6'b000100;
parameter SRLV = 6'b000110;
parameter SRAV = 6'b000111;
parameter LUI = 6'b001111;

always @(*) begin
    case (aluc)
        // Arithmetic Operations
        ADD: begin
            {carry, r} = a + b;
            overflow = (a[31] == b[31] && a[31]!= r[31]);
        end
        ADDU: begin
            {carry, r} = a + b;
            overflow = 1'b0;
        end
        SUB: begin
            {carry, r} = a - b;
            overflow = (a[31]!= b[31] && a[31]!= r[31]);
        end
        SUBU: begin
            {carry, r} = a - b;
            overflow = 1'b0;
        end
        
        // Logical Operations
        AND: begin
            r = a & b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        OR: begin
            r = a | b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        XOR: begin
            r = a ^ b;
            carry = 1'b0;
            overflow = 1'b0;
        end
        NOR: begin
            r = ~(a | b);
            carry = 1'b0;
            overflow = 1'b0;
        end
        
        // Comparison Operations
        SLT: begin
            r = ($signed(a) < $signed(b))? 32'd1 : 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = (r == 32'd1);
        end
        SLTU: begin
            r = (a < b)? 32'd1 : 32'd0;
            carry = 1'b0;
            overflow = 1'b0;
            flag = (r == 32'd1);
        end
        
        // Shift Operations
        SLL: begin
            r = a << b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRL: begin
            r = a >> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRA: begin
            r = $signed(a) >>> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SLLV: begin
            r = a << b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRLV: begin
            r = a >> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        SRAV: begin
            r = $signed(a) >>> b[4:0];
            carry = 1'b0;
            overflow = 1'b0;
        end
        
        // Load Upper Immediate
        LUI: begin
            r = {a[15:0], 16'd0};
            carry = 1'b0;
            overflow = 1'b0;
        end
        
        default: begin
            r = 32'bx;
            carry = 1'bx;
            overflow = 1'bx;
        end
    endcase

    // Status Flags
    zero = (r == 32'd0);
    negative = r[31];
end

endmodule