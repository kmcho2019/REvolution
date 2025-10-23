module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0;  // synchronous reset
    end else begin
        q <= d;     // load data
    end
end

endmodule