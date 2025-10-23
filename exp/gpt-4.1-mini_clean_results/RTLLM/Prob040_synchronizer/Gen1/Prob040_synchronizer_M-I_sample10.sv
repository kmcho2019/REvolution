module synchronizer (
    input           clk_a,
    input           clk_b,
    input           arstn,
    input           brstn,
    input   [3:0]   data_in,
    input           data_en,
    output reg [3:0] dataout
);

// Registers in clk_a domain
reg [3:0] data_reg;
reg       en_data_reg;

// Registers in clk_b domain for enable synchronization
reg en_clap_one;
reg en_clap_two;

// Data register and enable register update in clk_a domain
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg <= data_in;
        en_data_reg <= data_en;
    end
end

// Enable signal synchronizer in clk_b domain (2-stage synchronizer)
// Update only when there is a change or enable is high to reduce toggling
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        if (en_data_reg != en_clap_one || en_data_reg == 1'b1)
            en_clap_one <= en_data_reg;
        // similarly gate en_clap_two update
        if (en_clap_one != en_clap_two || en_clap_one == 1'b1)
            en_clap_two <= en_clap_one;
    end
end

// Output data update in clk_b domain based on synchronized enable
// Update dataout only when en_clap_two is high; hold otherwise.
// Also update only if new data_reg differs to reduce unnecessary toggling.
reg [3:0] dataout_next;
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0;
    end else if (en_clap_two) begin
        if (dataout != data_reg)
            dataout <= data_reg;
    end
    // else hold previous dataout automatically
end

endmodule