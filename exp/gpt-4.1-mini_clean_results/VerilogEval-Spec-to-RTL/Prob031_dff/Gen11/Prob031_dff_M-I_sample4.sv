module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Single D flip-flop triggered on the positive edge of clk
    // Nonblocking assignment ensures correct synchronous behavior
    // synthesis attribute register_inference of q is "yes";  // Hint for some synthesis tools

    always @(posedge clk) begin
        q <= d;
    end
endmodule