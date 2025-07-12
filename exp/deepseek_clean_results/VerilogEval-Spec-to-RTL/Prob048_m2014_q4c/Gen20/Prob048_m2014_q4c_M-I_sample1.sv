module TopModule (
    // Clock and reset
    input  clk,
    input  r,
    
    // Data signals
    input  d,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0;  // Synchronous reset to 0
    end else begin
        q <= d;     // Normal data capture
    end
end

endmodule