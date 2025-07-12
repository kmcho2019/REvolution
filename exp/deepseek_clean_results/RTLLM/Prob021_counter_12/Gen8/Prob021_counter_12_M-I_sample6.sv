module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

reg [3:0] next_count;
wire gated_clk;

// Clock gating cell
assign gated_clk = clk & (valid_count | !rst_n);

always @(posedge gated_clk) begin
    if (!rst_n) begin
        out <= 4'b0000;
        next_count <= 4'b0001;
    end else if (valid_count) begin
        out <= next_count;
        next_count <= next_count + 1'b1;
    end
end

endmodule