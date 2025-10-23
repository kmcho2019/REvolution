module TopModule (
    input clk,
    input a,
    output q
);
    reg reg_a;

    // Register input 'a' on rising edge
    always @(posedge clk) begin
        reg_a <= a;
    end

    // Output is inverted registered 'a'
    assign q = ~reg_a;

endmodule