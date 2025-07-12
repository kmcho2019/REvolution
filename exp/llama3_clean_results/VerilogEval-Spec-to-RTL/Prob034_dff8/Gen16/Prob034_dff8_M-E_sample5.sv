module TopModule(
    input clk,
    input rst_n, // active-low reset signal
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset 'q' to 0 when reset is active
        q <= 8'b0;
    end else begin
        // Assign the value of 'd' to 'q' at each positive edge of the clock
        q <= d;
    end
end

endmodule