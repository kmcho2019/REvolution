module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

// Enable register to synchronize valid_count
reg count_enable;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
        count_enable <= 1'b0;
    end else begin
        // Sample valid_count into count_enable
        count_enable <= valid_count;
        if (count_enable) begin
            if (out == 4'd11)
                out <= 4'b0000;
            else
                out <= out + 1'b1;
        end
        // else hold the count value
    end
end

endmodule