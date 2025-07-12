module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire wrap_around = q[3] & ~q[2] & q[1];  // Detects 10 (1010) more efficiently
wire enable = ~wrap_around;              // Only enable counting when not at max

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;                   // Direct assignment for reset
    end
    else if (enable) begin              // Only increment when enabled
        q <= q + 1;
    end
    else begin                          // Automatic wrap-around when at 10
        q <= 4'b0001;
    end
end

endmodule