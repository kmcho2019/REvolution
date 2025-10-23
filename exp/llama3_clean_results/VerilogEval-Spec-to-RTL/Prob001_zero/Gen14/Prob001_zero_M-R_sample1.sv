module TopModule (
    output zero
);
    // Using an always block to assign a constant value to the output
    always @(*) begin
        zero = 1'b0;
    end
endmodule