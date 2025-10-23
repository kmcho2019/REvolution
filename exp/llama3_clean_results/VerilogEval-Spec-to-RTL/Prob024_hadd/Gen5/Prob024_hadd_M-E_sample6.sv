module TopModule (
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    output logic sum,  // Sum of a and b
    output logic cout  // Carry-out from the addition of a and b
);

// Use a case statement to implement the LUT for the half adder
always @(a, b) begin
    case ({a, b})
        2'b00: begin sum = 1'b0; cout = 1'b0; end
        2'b01: begin sum = 1'b1; cout = 1'b0; end
        2'b10: begin sum = 1'b1; cout = 1'b0; end
        2'b11: begin sum = 1'b0; cout = 1'b1; end
        default: begin sum = 1'bx; cout = 1'bx; end
    endcase
end

endmodule