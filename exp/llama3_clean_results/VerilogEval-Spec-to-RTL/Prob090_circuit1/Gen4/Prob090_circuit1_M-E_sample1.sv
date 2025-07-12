// TopModule implements a simple AND gate using a case statement.
// The output q is 1 only when both inputs a and b are 1.
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    output reg q  // Output q
);

// Always block to implement the AND logic using a case statement
always @(*) begin
    case ({a, b})
        2'b00: q = 1'b0;
        2'b01: q = 1'b0;
        2'b10: q = 1'b0;
        2'b11: q = 1'b1;
        default: q = 1'bx;  // Default case for unknown inputs
    endcase
end

endmodule