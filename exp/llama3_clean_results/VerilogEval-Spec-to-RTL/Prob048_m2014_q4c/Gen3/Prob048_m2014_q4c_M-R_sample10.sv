module TopModule(
    input clk,
    input d,
    input r,
    output reg q = 0 // Setting initial value here
);

always @(posedge clk) begin
    if (r) begin
        q <= 0;
    end else begin
        q <= d;
    end
end

endmodule