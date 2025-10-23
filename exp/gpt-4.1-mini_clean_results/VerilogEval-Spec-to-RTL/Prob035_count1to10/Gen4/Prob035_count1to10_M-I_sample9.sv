module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  [3:0] q
);

    // Local signal to detect wrap condition in a simplified manner
    wire wrap = (q[3] & q[1]) | (q == 4'd10); 
    // Explanation:
    // 10 in binary is 1010. Checking if MSB (q[3]) and q[1] are both 1 
    // catches '1010'. This logic can be simpler in hardware than a full 4-bit comparator.

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;              // synchronous reset to 1
        end else if (wrap) begin
            q <= 4'd1;              // wrap to 1 when reaching 10
        end else begin
            q <= q + 4'd1;          // increment otherwise
        end
    end

endmodule