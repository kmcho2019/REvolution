module TopModule(
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Asynchronous reset
always @(posedge ar) begin
    q <= 1'b0; // Reset output to 0 immediately when ar is high
end

// Synchronous update on positive clock edge
always @(posedge clk) begin
    if (!ar) begin
        q <= d; // Update output with d when ar is low
    end
end

endmodule