module TopModule (
    input  wire clk,     // Clock input
    input  wire rst_n,   // Active-low reset
    input  wire in,      // Input signal
    output reg  out      // Registered output
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 1'b0;  // Reset to 0
        end else begin
            out <= in;    // Register input
        end
    end

endmodule