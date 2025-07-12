module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (reset) begin
        // Explicitly reset each bit to 0 for clarity and efficiency
        for (int i = 0; i < 8; i++) begin
            q[i] <= 1'b0;
        end
    end else begin
        // Load data into q on the positive edge of clk when reset is low
        q <= d;
    end
end

endmodule