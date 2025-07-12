// TopModule: Always drives output 'one' high, refactored structure using always block.
module TopModule(
    output one
);

// Use an always block to assign the constant value 1 to the output 'one'.
always @(*) begin
    one = 1'b1;
end

endmodule