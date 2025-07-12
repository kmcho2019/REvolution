module TopModule(
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

    // Instantiate 8 D flip-flops
    reg [7:0] q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset
            q_reg <= 8'b0;
        end else begin
            // DFF operation on the positive edge of clk
            q_reg <= d;
        end
    end

    // Continuous assignment to output
    assign q = q_reg;

endmodule