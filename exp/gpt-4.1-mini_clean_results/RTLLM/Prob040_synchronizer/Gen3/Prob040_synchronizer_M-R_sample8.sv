module synchronizer (
    input           clk_a,
    input           clk_b,
    input           arstn,
    input           brstn,
    input   [3:0]   data_in,
    input           data_en,
    output reg [3:0] dataout
);

// Data register in clk_a domain updated only when data_en is high
reg [3:0] data_reg;
reg       en_data_reg;

// Enable synchronizer in clk_b domain for metastability robustness
reg en_sync_0, en_sync_1;

// Intermediate wire to hold selected data value
wire [3:0] selected_data;

// clk_a domain: update data_reg only when data_en is high, en_data_reg always follows data_en
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        en_data_reg <= data_en;
        if (data_en)
            data_reg <= data_in;
    end
end

// clk_b domain: synchronize en_data_reg crossing from clk_a domain
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_sync_0 <= 1'b0;
        en_sync_1 <= 1'b0;
    end else begin
        en_sync_0 <= en_data_reg;
        en_sync_1 <= en_sync_0;
    end
end

// Select data_reg when delayed enable is high, else hold previous dataout
assign selected_data = en_sync_1 ? data_reg : dataout;

// clk_b domain: register output data
always @(posedge clk_b or negedge brstn) begin
    if (!brstn)
        dataout <= 4'b0;
    else
        dataout <= selected_data;
end

endmodule