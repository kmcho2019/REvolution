module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0; // reset output to 0
    end else begin
        q <= d; // capture input 'd' on the rising edge of 'clk'
    end
end

endmodule