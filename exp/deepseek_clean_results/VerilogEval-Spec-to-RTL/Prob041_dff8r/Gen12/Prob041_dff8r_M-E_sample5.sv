module TopModule #(
    parameter WIDTH = 8,
    parameter RESET_VAL = 8'b0
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    // Reset shadow register
    reg reset_shadow;

    always @(posedge clk) begin
        // Update reset shadow first
        reset_shadow <= reset;

        // Implement circular buffer with synchronous reset
        if (reset_shadow) begin
            q <= RESET_VAL;  // Bitwise reset
        end else begin
            q <= d;          // Normal operation
        end
    end

endmodule