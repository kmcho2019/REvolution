module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : segment
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                Q[i*8 +: 8] <= 8'b0;
            end
            else begin
                // First segment gets inverted LSB from last segment
                if (i == 0) begin
                    Q[i*8 +: 8] <= {~Q[63], Q[i*8+7 : i*8+1]};
                end
                // Other segments get LSB from previous segment
                else begin
                    Q[i*8 +: 8] <= {Q[(i-1)*8], Q[i*8+7 : i*8+1]};
                end
            end
        end
    end
endgenerate

endmodule