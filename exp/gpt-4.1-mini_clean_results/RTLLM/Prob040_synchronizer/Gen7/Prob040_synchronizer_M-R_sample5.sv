module synchronizer (
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
    reg       en_reg;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'd0;
            en_reg   <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_reg   <= data_en;
        end
    end

    // Synchronizer chain for enable signal in clk_b domain
    localparam SYNC_STAGES = 2;
    reg [SYNC_STAGES-1:0] en_sync_chain;

    integer i;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_chain <= {SYNC_STAGES{1'b0}};
        end else begin
            en_sync_chain[0] <= en_reg;
            for (i = 1; i < SYNC_STAGES; i = i + 1) begin
                en_sync_chain[i] <= en_sync_chain[i-1];
            end
        end
    end

    // Output update: if last stage of enable sync is high, update output with data_reg, else retain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else begin
            dataout <= en_sync_chain[SYNC_STAGES-1] ? data_reg : dataout;
        end
    end

endmodule