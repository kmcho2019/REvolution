// Novel solution using a look-up table
module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Use a case statement to implement the look-up table
always @(*)
begin
    case ({a, b, c})
        3'b000: out = 1'b0;
        3'b001: out = 1'b1;
        3'b010: out = 1'b1;
        3'b011: out = 1'b1;
        3'b100: out = 1'b1;
        3'b101: out = 1'b1;
        3'b110: out = 1'b1;
        3'b111: out = 1'b1;
        default: out = 1'bx; // default value for unknown inputs
    endcase
end

endmodule