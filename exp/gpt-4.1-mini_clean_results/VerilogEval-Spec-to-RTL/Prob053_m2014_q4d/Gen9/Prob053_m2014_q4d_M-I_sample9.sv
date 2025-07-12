module TopModule (
    input clk,
    input in,
    output reg out
);

    wire next_out = in ^ out;
    wire enable = (next_out != out);

    always @(posedge clk) begin
        if (enable)
            out <= next_out;
        // else retain previous 'out' value, no toggling occurs
    end

endmodule