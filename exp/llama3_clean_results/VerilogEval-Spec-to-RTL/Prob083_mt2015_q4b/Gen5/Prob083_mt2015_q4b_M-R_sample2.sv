module TopModule(
    input x,
    input y,
    output z
);

// Refactored using always block for combinational logic
always @(*) begin
    z = ~(x ^ y);
end

// Alternatively, could express directly as before:
// assign z = ~(x ^ y);

// Or, using AND and OR gates to implement equality:
// assign z = (x && y) || (!x &&!y);

endmodule