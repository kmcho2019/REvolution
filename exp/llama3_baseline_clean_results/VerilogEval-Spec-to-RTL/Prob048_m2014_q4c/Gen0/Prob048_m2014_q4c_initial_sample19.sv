module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0; // reset to 0 when r is high at posedge clk
    end else begin
        q <= d; // load d into q when r is low at posedge clk
    end
end

endmodule