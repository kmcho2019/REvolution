module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

reg valid_count_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
        valid_count_reg <= 1'b0;
    end else begin
        valid_count_reg <= valid_count; // Synchronize valid_count input
        if (valid_count_reg) begin
            if (out == 4'd11)
                out <= 4'b0000;
            else
                out <= out + 1;
        end
        // If valid_count_reg is 0, hold current count
    end
end

endmodule