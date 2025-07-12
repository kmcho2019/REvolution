module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 0; // Reset q to 0 when r is high
    end else begin
        q <= d; // Update q with d when r is low
    end
end

initial begin
    q = 0; // Ensure q has a defined initial state
end

endmodule