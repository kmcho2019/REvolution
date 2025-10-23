// TopModule with 8 D Flip-Flops
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 'b0;
        end else begin
            for (int i = 0; i < 8; i++) begin
                q_reg[i] <= d[i];
            end
        end
    end

    assign q = q_reg;

endmodule