module TopModule (
    input clk,
    input in,
    output reg out
);

    // Initialize output to 0 for simulation to avoid unknown startup state
    initial begin
        out = 0;
    end

    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule