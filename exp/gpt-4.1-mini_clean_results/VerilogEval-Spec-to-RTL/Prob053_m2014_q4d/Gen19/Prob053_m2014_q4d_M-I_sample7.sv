module TopModule (
    input clk,
    input in,
    output reg out = 1'b0  // Initialize out to zero for deterministic simulation
);

    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule