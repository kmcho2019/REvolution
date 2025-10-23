module TopModule (
    input clk,
    input rst_n,  // Active-low asynchronous reset
    input in,
    output reg out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            out <= 1'b0;
        else
            out <= in ^ out;
    end

endmodule