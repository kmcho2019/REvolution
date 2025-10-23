module TopModule(
    input clk,
    input d,
    input enable, // New enable signal
    output reg q
);

always @(posedge clk) begin
    if (enable) begin
        q <= d;
    end else begin
        // If enable is low, retain the current value of q
        q <= q;
    end
end

endmodule