module TopModule (
    input clk,
    input d,
    output reg q,
    input rst_n  // Active-low asynchronous reset
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 1'b0;  // Reset state
    end
    else begin
        q <= d;     // Normal operation
    end
end

endmodule