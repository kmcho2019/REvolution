module TopModule(
    input  a,
    input  b,
    input  op, // Operation control signal
    output out_assign, // Fixed AND operation
    output out_alwaysblock // Configurable operation
);

// Fixed AND operation using assign statement
assign out_assign = a & b;

// Configurable operation using combinational always block
always @(*) begin
    case(op)
        0: out_alwaysblock = a & b; // AND operation
        1: out_alwaysblock = a | b; // OR operation
        2: out_alwaysblock = a ^ b; // XOR operation
        default: out_alwaysblock = 1'b0; // Default to 0 for unknown operations
    endcase
end

endmodule