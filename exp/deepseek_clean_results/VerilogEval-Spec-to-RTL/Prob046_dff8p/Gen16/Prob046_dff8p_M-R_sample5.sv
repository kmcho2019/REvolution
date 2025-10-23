module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// Reset value is 0x34 (00110100)
localparam [7:0] RESET_VAL = 8'b00110100;

always @(negedge clk) begin
    if (reset) begin
        q <= RESET_VAL;
    end else begin
        q <= d;
    end
end

endmodule