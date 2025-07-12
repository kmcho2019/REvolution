module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// For power optimization: consider adding enable signal and clock gating
// For area optimization: consider Gray code if binary output not required

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;  // Synchronous reset
    end else begin
        // Separate increment/decrement paths for potential PPA optimization
        count <= up_down ? count + 1'b1 : count - 1'b1;
    end
end

endmodule