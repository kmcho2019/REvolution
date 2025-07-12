module alu(
    input [31:0] a,
    input [31:0] b,
    input [5:0] aluc,
    output [31:0] r,
    output zero,
    output carry_out,
    output negative,
    output overflow_out,
    output flag
);

// Define parameters for operations
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

// Declare internal registers for result, carry, and overflow
reg [31:0] result;
reg carry_int;
reg overflow_int;

// Always block to perform operations based on aluc
always @(*) begin
    // Initialize carry and overflow to 0
    carry_int = 0;
    overflow_int = 0;

    // Perform operation based on aluc
    case (aluc)
        // Arithmetic operations
        ADD, ADDU: begin
            // Add a and b, and check for carry and overflow
            {carry_int, result} = a + b;
            overflow_int = (a[31] == b[31] && result[31]!= a[31]);
        end
        SUB, SUBU: begin
            // Subtract b from a, and check for carry and overflow
            {carry_int, result} = a - b;
            overflow_int = (a[31]!= b[31] && result[31]!= a[31]);
        end
        
        // Bitwise operations
        AND: result = a & b; // Bitwise AND operation
        OR: result = a | b; // Bitwise OR operation
        XOR: result = a ^ b; // Bitwise XOR operation
        NOR: result = ~(a | b); // Bitwise NOR operation
        
        // Comparison operations
        SLT: result = (signed'(a) < signed'(b))? 32'h1 : 32'h0; // Set if a is less than b
        SLTU: result = (a < b)? 32'h1 : 32'h0; // Set if a is less than b (unsigned)
        
        // Shift operations
        SLL: result = a << b[4:0]; // Shift left by b[4:0] bits
        SRL: result = a >> b[4:0]; // Shift right by b[4:0] bits
        SRA: result = a >>> b[4:0]; // Shift right by b[4:0] bits (arithmetic)
        SLLV: result = a << a[4:0]; // Shift left by a[4:0] bits
        SRLV: result = a >> a[4:0]; // Shift right by a[4:0] bits
        SRAV: result = a >>> a[4:0]; // Shift right by a[4:0] bits (arithmetic)
        
        // Load upper immediate operation
        LUI: result = {16'd0, a[15:0]}; // Load upper immediate
        
        // Default: high-impedance
        default: result = 32'bz;
    endcase
end

// Assign outputs
assign r = result;
assign zero = (result == 32'h0);
assign carry_out = carry_int;
assign negative = result[31];
assign overflow_out = overflow_int;
assign flag = (aluc == SLT || aluc == SLTU)? result[0] : 1'b0;

endmodule