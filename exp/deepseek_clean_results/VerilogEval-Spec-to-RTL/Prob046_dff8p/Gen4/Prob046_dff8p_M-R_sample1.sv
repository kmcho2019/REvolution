module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

localparam RESET_VAL = 8'h34;  // Binary: 00110100

reg [7:0] q_reg;

// Negative edge triggered flip-flops with synchronous reset
always @(negedge clk) begin
    if (reset) begin
        q_reg <= RESET_VAL;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule