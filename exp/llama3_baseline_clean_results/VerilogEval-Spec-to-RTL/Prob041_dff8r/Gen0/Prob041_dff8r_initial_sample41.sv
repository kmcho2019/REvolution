module TopModule(
    input  clk,
    input  reset,
    input  [7:0] d,
    output [7:0] q
);

always_ff @(posedge clk) begin
    if (reset) begin
        q <= 8'd0; // Set output to zero when reset is high
    end else begin
        q <= d; // Load input data when reset is low
    end
end

endmodule