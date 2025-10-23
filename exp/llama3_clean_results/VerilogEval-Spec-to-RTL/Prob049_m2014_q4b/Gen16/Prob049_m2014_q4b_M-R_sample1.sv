module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge ar or posedge clk) begin
    if (ar) begin
        q <= 1'b0; // Prioritize asynchronous reset
    end else if (clk) begin // Considering clk is used for positive edge triggering
        q <= d; // Update on positive clock edge if no reset
    end
end

endmodule