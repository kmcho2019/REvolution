module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q,
    // Optional control signals (tied off when unused)
    input  wire reset_n,  // Active-low asynchronous reset
    input  wire en        // Clock enable
);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        q <= 1'b0;  // Reset value
    end
    else if (en) begin
        q <= d;      // Normal operation
    end
end

endmodule