module TopModule (
    input clk,
    input in,
    output reg out
);

    // Initialize output to 0 for simulation stability, no reset in hardware
    initial begin
        out = 0;
    end

    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule