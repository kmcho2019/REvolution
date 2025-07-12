module TopModule (
    input clk,
    input in,
    output reg out
);

    wire d_in;
    assign d_in = in ^ out;

    always @(posedge clk) begin
        out <= d_in;
    end

endmodule