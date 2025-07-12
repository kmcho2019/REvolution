module TopModule (
    input clk,
    input d,
    output q
);

    reg q_reg;

    // Register d on positive edge of clk
    always @(posedge clk) begin
        q_reg <= d;
    end

    // Output driven by registered signal
    assign q = q_reg;

endmodule