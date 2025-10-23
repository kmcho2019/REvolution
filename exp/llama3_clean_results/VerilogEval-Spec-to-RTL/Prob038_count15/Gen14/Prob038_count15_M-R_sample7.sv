module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Always block for handling reset condition
always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0; // Reset the counter to 0
    end
end

// Always block for incrementing the counter
always @(posedge clk) begin
    if (!reset) begin
        q <= (q == 4'd15) ? 4'd0 : q + 1; // Increment or wrap around
    end
end

endmodule