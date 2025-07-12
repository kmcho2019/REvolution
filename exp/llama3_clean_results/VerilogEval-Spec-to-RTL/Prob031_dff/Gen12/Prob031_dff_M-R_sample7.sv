module TopModule(
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    if (1'b1) begin // This is always true, similar to using @(posedge clk) directly
        q <= d; // Use non-blocking assignment for sequential logic update
    end
end

endmodule