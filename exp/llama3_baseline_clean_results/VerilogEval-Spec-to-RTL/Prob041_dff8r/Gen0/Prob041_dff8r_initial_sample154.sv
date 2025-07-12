module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'd0; // Synchronous reset, set output to zero
    end else begin
        q <= d; // Assign input data to output when reset is low
    end
end

endmodule