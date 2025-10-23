module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg wrap_condition;

always @(posedge clk) begin
    wrap_condition <= q[3] & q[1];  // Registered detection of 10 (1010)
    
    if (reset) begin
        q <= 4'b0001;              // Highest priority: synchronous reset
    end
    else if (wrap_condition) begin
        q <= 4'b0001;              // Wrap around to 1 after 10
    end
    else begin
        q <= q + 4'b0001;          // Normal increment
    end
end

endmodule