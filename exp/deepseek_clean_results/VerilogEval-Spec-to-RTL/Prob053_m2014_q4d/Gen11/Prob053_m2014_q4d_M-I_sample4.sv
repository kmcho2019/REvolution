module TopModule (
    input clk,
    input in,
    output reg out
);

    initial out = 0;  // Simulation-only initialization

    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule