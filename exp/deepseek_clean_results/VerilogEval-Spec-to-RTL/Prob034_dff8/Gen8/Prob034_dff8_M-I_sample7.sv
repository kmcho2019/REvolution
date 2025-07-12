module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q,
    input reset_n    // Optional active-low asynchronous reset
);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        q <= 8'b0;    // Reset to 0 when reset_n is low
    end else begin
        q <= d;       // Normal operation
    end
end

endmodule