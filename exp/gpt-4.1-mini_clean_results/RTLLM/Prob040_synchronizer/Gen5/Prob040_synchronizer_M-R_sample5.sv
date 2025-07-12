module synchronizer (
    input           clk_a,
    input           clk_b,
    input           arstn,
    input           brstn,
    input   [3:0]   data_in,
    input           data_en,
    output reg [3:0] dataout
);

// Data register stores data_in when data_en is asserted in clk_a domain
reg [3:0] data_reg;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn)
        data_reg <= 4'b0;
    else if (data_en)
        data_reg <= data_in;
end

// Enable synchronizer implemented as a 2-bit shift register updated on clk_b domain
reg [1:0] en_sync_shift;

always @(posedge clk_b or negedge brstn) begin
    if (!brstn)
        en_sync_shift <= 2'b00;
    else
        en_sync_shift <= {en_sync_shift[0], data_en};
end

wire en_sync_2 = en_sync_shift[1];

// Update output dataout only when delayed enable is high to avoid redundant toggling
always @(posedge clk_b or negedge brstn) begin
    if (!brstn)
        dataout <= 4'b0;
    else if (en_sync_2)
        dataout <= data_reg;
    else
        dataout <= dataout; // hold previous value
end

endmodule