// Refactored version using an initial block
module TopModule (
    output zero
);
initial begin
    zero = 1'b0;
end
endmodule

// Refactored version using an always block (not recommended for this simple case due to performance considerations)
module TopModule (
    output zero
);
always @(*) begin
    zero = 1'b0;
end
endmodule