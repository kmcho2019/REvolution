module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

// Detect when out == 11 (4'b1011)
wire count_max = (out[3] & ~out[2] & out[1] & out[0]);

always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        if (count_max)
            out <= 4'b0000;
        else
            out <= out + 1'b1;
    end
    // else retain current out to save switching
end

endmodule