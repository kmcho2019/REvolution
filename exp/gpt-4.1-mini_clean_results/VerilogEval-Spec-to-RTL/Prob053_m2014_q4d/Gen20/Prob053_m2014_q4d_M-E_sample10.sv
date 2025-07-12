module TopModule (
    input  clk,
    input  in,
    output reg out
);

    wire d;  // D input to the flip-flop

    assign d = in ^ out;

    always @(posedge clk) begin
        out <= d;
    end

endmodule