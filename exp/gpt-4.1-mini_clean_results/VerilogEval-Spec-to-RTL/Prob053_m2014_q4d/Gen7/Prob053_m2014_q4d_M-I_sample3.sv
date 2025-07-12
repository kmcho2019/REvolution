module TopModule (
    input clk,
    input in,
    output reg out
);

    wire d = in ^ out;
    wire ce = d;  // Clock enable: only update when output changes

    always @(posedge clk) begin
        if (ce)
            out <= d;
    end

endmodule