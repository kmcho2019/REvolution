module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 8'd0; // Synchronous reset, setting output to zero
    end else begin
        q <= d; // Load input data into the register on the positive edge of the clock
    end
end

endmodule