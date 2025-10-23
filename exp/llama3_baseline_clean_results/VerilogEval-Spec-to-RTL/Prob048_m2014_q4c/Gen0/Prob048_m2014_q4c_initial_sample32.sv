module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0; // reset to 0 when r is high
    end else begin
        q <= d; // update q with d when r is low
    end
end

endmodule