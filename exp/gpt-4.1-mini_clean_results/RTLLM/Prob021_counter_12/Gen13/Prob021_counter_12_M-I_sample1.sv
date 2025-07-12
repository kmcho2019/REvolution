module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

// Enable counting logic when valid_count is high or during reset
wire count_en = valid_count || !rst_n;

always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (count_en) begin
        if (out == 4'd11)
            out <= 4'b0000;
        else if (valid_count)
            out <= out + 1'b1;
        else
            out <= out; // Hold count if only reset_en active but valid_count = 0
    end
    // else hold current count
end

endmodule