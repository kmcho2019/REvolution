module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

localparam RESET_VALUE = 8'h34;  // Binary: 00110100

always @(negedge clk) begin
    if (reset) begin
        // XOR with RESET_VALUE to set specific bits while clearing others
        q <= d ^ (d ^ RESET_VALUE);
    end else begin
        q <= d;
    end
end

endmodule