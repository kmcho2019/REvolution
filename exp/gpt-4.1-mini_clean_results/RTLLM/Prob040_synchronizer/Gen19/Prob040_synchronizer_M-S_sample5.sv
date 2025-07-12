module synchronizer(
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

// Register data and enable in clk_a domain
reg [3:0] data_reg;
reg       en_data_reg;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg     <= 4'd0;
        en_data_reg  <= 1'b0;
    end else begin
        data_reg     <= data_in;
        en_data_reg  <= data_en;
    end
end

// Two-stage synchronization of enable signal to clk_b domain
reg [1:0] en_sync_b;

always @(posedge clk_b or negedge brstn) begin
    if (!brstn)
        en_sync_b <= 2'b00;
    else
        en_sync_b <= {en_sync_b[0], en_data_reg};
end

// Output update with mux controlled by synchronized enable
always @(posedge clk_b or negedge brstn) begin
    if (!brstn)
        dataout <= 4'd0;
    else if (en_sync_b[1])
        dataout <= data_reg;
end

endmodule