module TopModule(
    input clk,
    input in,
    output reg out
);

    always @ (posedge clk) begin
        out <= in ^ out;
    end

    initial begin
        out = 1'b0; // Initialize out to 0
    end

endmodule