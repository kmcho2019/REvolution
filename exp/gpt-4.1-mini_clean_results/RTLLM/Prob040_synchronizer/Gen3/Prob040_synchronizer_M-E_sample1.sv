module synchronizer (
    input           clk_a,
    input           clk_b,
    input           arstn,
    input           brstn,
    input   [3:0]   data_in,
    input           data_en,
    output reg [3:0] dataout
);

// clk_a domain registers
reg [3:0] data_reg;
reg       en_data_reg;

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg     <= 4'b0;
        en_data_reg  <= 1'b0;
    end else begin
        if (data_en) begin
            data_reg    <= data_in;
            en_data_reg <= 1'b1;
        end else begin
            en_data_reg <= 1'b0;
        end
    end
end

// clk_b domain: Two-stage synchronizer for enable signal
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

// clk_b domain: Two-stage synchronizer for data_reg from clk_a domain
reg [3:0] data_sync_stage1;
reg [3:0] data_sync_stage2;

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_sync_stage1 <= 4'b0;
        data_sync_stage2 <= 4'b0;
    end else begin
        // sample data_reg asynchronously, assuming data_reg stable during en_data_reg high
        data_sync_stage1 <= data_reg;
        data_sync_stage2 <= data_sync_stage1;
    end
end

// Output register update with MUX controlled by en_clap_two
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0;
    end else begin
        if (en_clap_two) begin
            dataout <= data_sync_stage2;
        end else begin
            dataout <= dataout;  // hold previous value when not enabled
        end
    end
end

endmodule