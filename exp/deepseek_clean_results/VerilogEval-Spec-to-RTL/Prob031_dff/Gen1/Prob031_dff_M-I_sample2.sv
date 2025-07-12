module TopModule (
    input clk,
    input d,
    output reg q,
    input rst_n  // Active-low asynchronous reset
);

parameter ACTIVE_LOW_RESET = 1;  // Configurable reset polarity

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule