module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin // Synchronous reset condition
        q <= 1'b0; // Reset output to 0
    end else begin
        q <= d; // Capture data on rising edge of clock
    end
end

endmodule