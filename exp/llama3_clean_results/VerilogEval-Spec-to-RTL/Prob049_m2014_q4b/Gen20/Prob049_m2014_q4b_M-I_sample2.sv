module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0; // Reset to 0 on asynchronous reset
    end else if (posedge clk) begin // Use posedge clk to ensure proper triggering
        q <= d;
    end
end

endmodule