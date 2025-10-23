module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 0; // Reset q to 0 if reset signal is high
    end else begin
        q <= d; // Load input data into q if reset signal is low
    end
end

endmodule