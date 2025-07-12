module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg;
reg en_clap_one;
reg en_clap_two;

// Simplified and optimized register update logic
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        en_clap_one <= 1'b0;
    end else if (data_en) begin
        // Only update data_reg when data_en is high
        data_reg <= data_in;
        en_clap_one <= 1'b1;
    end
end

// Clock gated logic for clk_b domain to reduce power consumption
reg clk_b_gated;
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        clk_b_gated <= 1'b0;
        en_clap_two <= 1'b0;
        dataout <= 4'd0;
    end else if (en_clap_one) begin
        // Enable clock gating for the clk_b domain when en_clap_one is high
        clk_b_gated <= 1'b1;
        en_clap_two <= en_clap_one;
        if (en_clap_two) begin
            dataout <= data_reg;
        end
    end else begin
        clk_b_gated <= 1'b0;
    end
end

endmodule