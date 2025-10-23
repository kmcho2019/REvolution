module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

    // Instantiate 8 D flip-flops
    reg [7:0] q_reg;

    always @(posedge clk) begin
        q_reg <= d;
    end

    // Continuous assignment for output
    assign q = q_reg;

endmodule