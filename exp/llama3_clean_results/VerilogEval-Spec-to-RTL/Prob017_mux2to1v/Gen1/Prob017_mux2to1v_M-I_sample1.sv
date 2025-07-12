module TopModule(
    input [99:0] a,  // 100 bits
    input [99:0] b,  // 100 bits
    input sel,
    output [99:0] out // 100 bits
);

// Using a case statement for potential synthesis optimization
always @(a, b, sel) begin
    case(sel)
        1'b0: out = a;
        1'b1: out = b;
        default: out = 100'b0; // Default case for completeness
    endcase
end

endmodule