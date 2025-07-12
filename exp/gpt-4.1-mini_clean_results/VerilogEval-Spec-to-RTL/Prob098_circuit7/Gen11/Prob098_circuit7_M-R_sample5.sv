module TopModule (
    input clk,
    input a,
    output q
);
    reg a_reg;

    // Register input 'a' on positive clock edge
    always @(posedge clk) begin
        a_reg <= a;
    end

    // Assign q as inverted registered value
    assign q = ~a_reg;

endmodule