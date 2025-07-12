module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow,
    output flag
);

// Parameters for different operations
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

// Internal wires for signed operations
wire signed [31:0] a_signed;
wire signed [31:0] b_signed;

assign a_signed = a;
assign b_signed = b;

// Internal reg for result
reg [31:0] res;

// Assign output 'r' to the lower 32 bits of the result register
assign r = res;

// Determine flag output based on the control signal
assign flag = (aluc == SLT || aluc == SLTU) ? (a_signed < b_signed) : 1'bz;

// Determine zero output based on the result
assign zero = (res == 32'd0) ? 1'b1 : 1'b0;

// Determine negative output based on the result
assign negative = res[31];

// Determine carry and overflow
wire carry_temp;
wire overflow_temp;

assign carry_temp = (aluc == ADD || aluc == ADDU) ? (a[31] & b[31] & ~res[31]) : 
                   (aluc == SUB || aluc == SUBU) ? (a[31] & ~b[31] & ~res[31]) : 1'b0;

assign overflow_temp = (aluc == ADD || aluc == SUB) ? (a[31] != b[31] && b[31] == res[31]) : 1'b0;

assign carry = carry_temp;
assign overflow = overflow_temp;

// Main always block for ALU operations
always @(*)
begin
    case (aluc)
        // Addition operations
        ADD, ADDU: res = a + b;
        SUB, SUBU: res = a - b;
        
        // Bitwise operations
        AND: res = a & b;
        OR: res = a | b;
        XOR: res = a ^ b;
        NOR: res = ~(a | b);
        
        // Shift operations
        SLL: res = a << b[4:0];
        SRL: res = a >> b[4:0];
        SRA: res = a_signed >>> b[4:0];
        SLLV: res = a << a[4:0];
        SRLV: res = a >> a[4:0];
        SRAV: res = a_signed >>> a[4:0];
        
        // Load upper immediate operation
        LUI: res = {a[15:0], 16'd0};
        
        // Comparison operations
        SLT: res = (a_signed < b_signed) ? 32'd1 : 32'd0;
        SLTU: res = (a < b) ? 32'd1 : 32'd0;
        
        // Default case: assign high-impedance
        default: res = 32'bz;
    endcase
end

endmodule