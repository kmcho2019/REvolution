module TopModule (
    input clk,
    input d,
    output reg q,
    input rst_n  // Added asynchronous active-low reset
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 1'b0;  // Reset value
    end else begin
        q <= d;
    end
end

endmodule