module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);

    reg q_reg;

    // Sequential logic: capture d on rising edge of clk
    always @(posedge clk) begin
        q_reg <= d;
    end

    // Continuous assignment of output from internal register
    assign q = q_reg;

endmodule