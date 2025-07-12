module TopModule (
    input  wire clk,
    input  wire in,
    output reg  out
);

    // On every positive edge of clk, update out as XOR of in and current out
    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule