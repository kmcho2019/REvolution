module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting
    output reg [3:0] out       // 4-bit counter output
);

// Next state computation
wire [3:0] next_out;
assign next_out = (out == 4'd11) ? 4'd0 : (out + 1'b1);

always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end
    else begin
        out <= valid_count ? next_out : out;
    end
end

endmodule