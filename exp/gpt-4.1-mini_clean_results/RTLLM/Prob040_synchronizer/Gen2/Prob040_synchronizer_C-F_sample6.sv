module synchronizer (
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

// Registers in clk_a domain
reg [3:0] data_reg;
reg       en_data_reg;

// Update data_reg and en_data_reg only when data_en is high to reduce toggling
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg    <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        if (data_en) begin
            data_reg    <= data_in;
            en_data_reg <= data_en;
        end else begin
            // hold previous values implicitly
            data_reg    <= data_reg;
            en_data_reg <= en_data_reg;
        end
    end
end

// Two-stage synchronizer for enable signal crossing clk domains
reg en_clap_one, en_clap_two;
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
        dataout     <= 4'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
        // Update dataout only when en_clap_two is high to prevent toggling
        if (en_clap_two)
            dataout <= data_reg;
        // else hold previous dataout implicitly (no redundant assignment)
    end
end

endmodule