module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin // Handling reset condition
        q <= 1'b0; // Explicitly setting q to 0
    end else begin
        q <= d; // Capturing input d on rising edge of clk
    end
end

endmodule