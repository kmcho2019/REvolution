module TopModule (
    input clk,
    input in,
    output reg out
);

    wire next_out;

    assign next_out = in ^ out;

    always @(posedge clk) begin
        out <= next_out;
    end

endmodule