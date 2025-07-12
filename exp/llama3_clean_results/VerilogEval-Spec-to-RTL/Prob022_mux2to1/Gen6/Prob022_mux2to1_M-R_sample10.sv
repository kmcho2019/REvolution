module TopModule(
    input  a,
    input  b,
    input  sel,
    output reg out
);
always @(*) begin
    // Use the ternary operator for simplicity and efficiency within the always block
    out = sel ? b : a;
end
endmodule