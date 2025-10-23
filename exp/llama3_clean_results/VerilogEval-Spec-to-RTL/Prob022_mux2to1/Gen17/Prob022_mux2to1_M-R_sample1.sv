// Module declaration for a 2-to-1 multiplexer
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    input  sel, // Select input
    output reg out  // Output
);

// Implement a 2-to-1 multiplexer using an always block
always @(*) begin
    case (sel)
        1'b0: out = a;
        1'b1: out = b;
        default: out = 1'bx; // Handle unknown or high-impedance input
    endcase
end

endmodule