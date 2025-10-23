module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// Clock gating signal - high when data changes
wire data_changed = (q != d);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;  // Synchronous reset
    end
    else if (data_changed) begin  // Only update when data changes
        q <= d;
    end
end

endmodule