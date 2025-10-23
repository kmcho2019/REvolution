module TopModule (
    input clk,
    input in,
    output reg out
);

    wire xor_in = in ^ out;

    initial begin
        out = 0;
    end

    always @(posedge clk) begin
        out <= xor_in;
    end

endmodule