module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

// Gated clock signal: active only when valid_count is high
wire gated_clk;
assign gated_clk = clk & valid_count;

always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else begin
        if (out == 4'd11)
            out <= 4'b0000;
        else
            out <= out + 1;
    end
end

// Hold output when valid_count is 0 implicitly since gated_clk won't toggle

endmodule