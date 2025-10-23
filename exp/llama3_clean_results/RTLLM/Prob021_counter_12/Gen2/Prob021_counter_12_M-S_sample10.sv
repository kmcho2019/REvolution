module counter_12 (
    input   rst_n,
    input   clk,
    input   valid_count,
    output reg [3:0] out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        out <= (out + 1'b1) % 12; // Wrap around after 11
    end
end

endmodule