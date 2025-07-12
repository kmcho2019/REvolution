module TopModule(
    input clk,
    input rst_n, // Active low reset
    input d,
    output reg q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set q to 0 when reset is active
        q <= 0;
    end else begin
        // Use non-blocking assignment for sequential logic
        q <= d;
    end
end

endmodule