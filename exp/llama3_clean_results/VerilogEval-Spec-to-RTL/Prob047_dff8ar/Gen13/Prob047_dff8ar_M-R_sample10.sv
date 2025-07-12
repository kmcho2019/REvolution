// Refactored TopModule with simplified structure
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg;

    assign q = (areset) ? 8'b0 : q_reg;

    always @(posedge clk) begin
        q_reg <= d;
    end

endmodule