module TopModule(
    input clk,
    input rst_n, // Active low reset
    input [7:0] d,
    output logic [7:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        q <= 8'b0; // Reset 'q' to zero when reset is active
    end else begin
        q <= d; // Update 'q' with 'd' at the positive edge of the clock
    end
end

endmodule