module TopModule (
    input clk,
    input in,
    output reg out = 1'b0  // initialized to zero to avoid unknown startup state in simulation
);

    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule