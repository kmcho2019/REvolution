module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

// Truth table for half adder
// a  | b  | sum | cout
// ----|----|-----|-----
// 0  | 0  | 0   | 0
// 0  | 1  | 1   | 0
// 1  | 0  | 1   | 0
// 1  | 1  | 0   | 1

// Using a case statement to implement the truth table
always @(*) begin
    case ({a, b})
        2'b00: begin sum = 0; cout = 0; end
        2'b01: begin sum = 1; cout = 0; end
        2'b10: begin sum = 1; cout = 0; end
        2'b11: begin sum = 0; cout = 1; end
    endcase
end

endmodule