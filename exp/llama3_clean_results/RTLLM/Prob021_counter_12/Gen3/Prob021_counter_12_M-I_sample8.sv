module counter_12 (
    input   rst_n,
    input   clk,
    input   valid_count,
    output reg [3:0] out
);

// Clock gating to reduce power consumption
reg clk_gated;
assign clk_gated = clk && valid_count;

always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        // Simplified conditional logic to reduce critical path delay
        if (out == 4'd11) begin
            out <= 4'b0000;
        end else begin
            out <= out + 1;
        end
    end
end

endmodule