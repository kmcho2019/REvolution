module TopModule(
    input  in,
    output reg out
);
    // Define a combinational logic block
    always @(*) begin
        // Invert the input and assign it to the output
        out = ~in;
    end
endmodule