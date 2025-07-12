module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

localparam MAX_COUNT = 4'd9;
localparam RESET_VAL = 4'd0;

always @(posedge clk) begin
    if (reset) begin
        q <= RESET_VAL;                 // Synchronous reset
    end
    else if (q == MAX_COUNT) begin      // Efficient terminal count detection
        q <= RESET_VAL;
    end
    else begin
        q <= q + 1'b1;                  // Normal increment
    end
end

endmodule