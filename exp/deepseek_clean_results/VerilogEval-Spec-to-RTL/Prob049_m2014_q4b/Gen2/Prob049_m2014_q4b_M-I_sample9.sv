module TopModule (
    input clk,
    input ar,    // Asynchronous reset (active high)
    input d,
    output reg q
);

// Positive edge-triggered DFF with async reset
// Reset takes precedence over clock
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;  // Clear output when reset is active
    end
    else begin
        q <= d;     // Capture input on rising clock edge
    end
end

endmodule