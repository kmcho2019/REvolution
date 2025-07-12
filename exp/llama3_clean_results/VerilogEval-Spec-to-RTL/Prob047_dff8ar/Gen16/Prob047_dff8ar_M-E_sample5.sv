// Novel TopModule with clock-gated 8-bit register and asynchronous reset
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg;

    // Clock-gating technique to reduce power consumption
    wire clk_gated = clk && !areset;

    always @(posedge clk_gated or posedge areset) begin
        if (areset) begin
            q_reg <= 8'b0;
        end else begin
            q_reg <= d;
        end
    end

    assign q = q_reg;

endmodule