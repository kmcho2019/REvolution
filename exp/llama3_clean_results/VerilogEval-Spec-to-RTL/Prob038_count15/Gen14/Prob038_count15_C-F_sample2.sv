module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

// Direct incrementation maintains simplicity and efficiency.
always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0
        q <= 4'd0; 
    end else begin
        // Direct incrementation of the counter
        q <= q + 1;
    end
end

endmodule