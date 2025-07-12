module TopModule(
    input  in1,
    input  in2,
    output reg out
);

always @(*) begin
    case ({in1, in2})
        2'b00: out <= 1'b1; // Both inputs are 0, output is 1
        2'b01, 2'b10, 2'b11: out <= 1'b0; // Any input is 1, output is 0
        default: out <= 1'bx; // Default case for any other input combination, though not applicable for 2-bit inputs
    endcase
end

endmodule