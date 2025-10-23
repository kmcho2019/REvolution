module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// Reset value 0x34 (binary: 00110100)
localparam RESET_VAL = 8'b00110100;

always @(negedge clk) begin
    if (reset) begin
        q <= RESET_VAL;
    end else begin
        q <= d;
    end
end

endmodule