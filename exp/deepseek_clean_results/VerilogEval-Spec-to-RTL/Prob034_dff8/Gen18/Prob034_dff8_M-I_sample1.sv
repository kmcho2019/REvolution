module TopModule (
    input clk,
    input rst_n,    // Active-low reset
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 8'h00;  // Reset to known state
    end
    else begin
        q <= d;      // Normal operation
    end
end

endmodule