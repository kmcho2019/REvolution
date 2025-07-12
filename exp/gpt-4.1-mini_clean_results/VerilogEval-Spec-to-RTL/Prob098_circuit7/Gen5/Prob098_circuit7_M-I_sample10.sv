module TopModule (
    input clk,
    input a,
    output q
);
    reg a_reg;

    always @(posedge clk) begin
        if (a != a_reg)  // Update only if 'a' changes
            a_reg <= a;
    end

    assign q = ~a_reg;
endmodule