module TopModule (
    input clk,
    input a,
    output q
);
    reg a_reg;

    // Register the input 'a' on the rising edge of clock
    always @(posedge clk) begin
        a_reg <= a;
    end

    // Output q is the inversion of the registered 'a_reg'
    assign q = ~a_reg;

endmodule