// TopModule with 8 D flip-flops and active high asynchronous reset
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg; // Internal register to hold the output

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 8'b0;
        end else begin
            q_reg <= d;
        end
    end

    assign q = q_reg;

endmodule