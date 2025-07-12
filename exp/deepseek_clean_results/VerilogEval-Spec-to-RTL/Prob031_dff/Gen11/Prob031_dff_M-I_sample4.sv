module TopModule (
    input clk,
    input d,
    input rst_n,    // Active-low asynchronous reset
    output reg q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 1'b0;  // Reset state
    else
        q <= d;     // Normal operation
end

endmodule