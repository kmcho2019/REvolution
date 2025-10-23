module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q;

always @(posedge clk) begin
    if (reset) begin
        q <= 8'd0; // reset q to zero when reset is high
    end else begin
        q <= d; // assign input d to output q when reset is low
    end
end

endmodule