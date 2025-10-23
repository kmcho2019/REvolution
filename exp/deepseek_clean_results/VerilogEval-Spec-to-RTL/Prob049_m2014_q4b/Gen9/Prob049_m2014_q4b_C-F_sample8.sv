module TopModule (
    input  clk,    // Positive edge clock input
    input  ar,     // Asynchronous active-high reset
    input  d,      // Data input
    output reg q   // Registered data output
);

    parameter RST_VAL = 1'b0;  // Configurable reset value

    // Positive-edge triggered DFF with async reset
    // Reset has priority over data input
    always @(posedge clk or posedge ar) begin
        if (ar) q <= RST_VAL;  // Async reset (active high)
        else    q <= d;        // Normal operation: capture input
    end

endmodule