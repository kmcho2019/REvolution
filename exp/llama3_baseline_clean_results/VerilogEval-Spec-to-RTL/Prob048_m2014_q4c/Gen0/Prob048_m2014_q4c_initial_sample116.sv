module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0; // reset output to 0 when reset is high
    end else begin
        q <= d; // update output with input when reset is low
    end
end

endmodule