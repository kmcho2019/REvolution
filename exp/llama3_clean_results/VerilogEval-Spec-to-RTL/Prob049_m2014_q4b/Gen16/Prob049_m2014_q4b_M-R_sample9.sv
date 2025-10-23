module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg reset_val, clk_val;

assign reset_val = (ar) ? 1'b0 : d;

always @(posedge clk) begin
    if (ar) begin
        q <= 1'b0; // Asynchronous reset
    end else begin
        q <= d; // Positive edge triggering of the clock
    end
end

// However, the better way to handle asynchronous reset in a separate always block for improved readability and potential synthesis benefits:
// always @(posedge ar) q <= 1'b0;
// always @(posedge clk) q <= d;

endmodule