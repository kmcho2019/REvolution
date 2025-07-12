module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

// Asynchronous reset
always @(*) begin
    if (ar) begin
        q <= 1'b0;
    end
end

// Clock edge triggered logic
always @(posedge clk) begin
    if (!ar) begin
        q <= d;
    end
end

endmodule