module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg toggle;  // 1-bit counter (toggles every input)
reg [8:0] stage1_sum;  // First stage sum (8+8 = max 510)
reg [9:0] stage2_sum;  // Second stage sum (510+510 = max 1020)
reg stage1_valid;      // Valid signal for pipeline stage

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle <= 1'b0;
        stage1_sum <= 9'b0;
        stage2_sum <= 10'b0;
        stage1_valid <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end
    else begin
        // Default outputs
        valid_out <= 1'b0;
        stage1_valid <= 1'b0;

        if (valid_in) begin
            // First pipeline stage: sum pairs of inputs
            if (!toggle) begin
                stage1_sum <= {1'b0, data_in};
            end
            else begin
                stage1_sum <= stage1_sum + data_in;
                stage1_valid <= 1'b1;
            end
            toggle <= ~toggle;

            // Second pipeline stage: sum the pairs
            if (stage1_valid) begin
                if (toggle) begin  // Every 4th input
                    data_out <= stage2_sum + stage1_sum;
                    valid_out <= 1'b1;
                    stage2_sum <= 10'b0;
                end
                else begin
                    stage2_sum <= stage2_sum + stage1_sum;
                end
            end
        end
    end
end

endmodule