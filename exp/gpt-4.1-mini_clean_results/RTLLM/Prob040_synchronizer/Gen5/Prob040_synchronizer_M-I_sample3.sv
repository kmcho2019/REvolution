module synchronizer(
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

// Register input data and enable in clk_a domain with async reset and clock enable
reg [3:0] data_reg;
reg       en_data_reg;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        // Only update when data_en is high to reduce unnecessary toggling
        if (data_en) begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end else begin
            // Keep previous values to avoid toggling
            data_reg <= data_reg;
            en_data_reg <= 1'b0;
        end
    end
end

// Enable synchronization registers directly inside the main module (clk_b domain)
reg en_clap_one, en_clap_two;

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Mux dataout update to reduce unnecessary toggling: update only when en_clap_two is active
wire update_en = en_clap_two;

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0;
    end else if (update_en) begin
        dataout <= data_reg;
    end else begin
        dataout <= dataout; // hold previous value to avoid toggling
    end
end

endmodule