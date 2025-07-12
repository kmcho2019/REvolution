module TopModule (
    input clk,
    input in,
    output reg out
);

    wire d_input;
    assign d_input = in ^ out;

    // Enable flip-flop update only when d_input differs from current out
    wire enable = (d_input != out);

    always @(posedge clk) begin
        if (enable)
            out <= d_input;
    end

endmodule