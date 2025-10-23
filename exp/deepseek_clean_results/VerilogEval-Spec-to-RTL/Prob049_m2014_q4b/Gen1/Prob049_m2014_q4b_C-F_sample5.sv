module TopModule (
    input clk,
    input ar,    // Asynchronous reset (active high)
    input d,     // Data input
    output reg q  // Data output
);

// Reset value parameter (could be made parameterizable if needed)
localparam RESET_VALUE = 1'b0;

always @(posedge clk or posedge ar) begin
    // Asynchronous reset has priority
    if (ar) begin
        q <= RESET_VALUE;
    end 
    // Normal operation - capture input on rising clock edge
    else begin
        q <= d;
    end
end

endmodule