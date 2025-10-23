module TopModule #(
    parameter WIDTH = 4
) (
    input  wire             clk,
    input  wire             reset, // synchronous active-high reset
    output reg  [WIDTH-1:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= {WIDTH{1'b0}}; // reset counter to 0 synchronously
    end else begin
        q <= q + 1'b1;      // increment counter by 1
    end
end

endmodule