module synchronizer (
    input           clk_a,
    input           clk_b,
    input           arstn,
    input           brstn,
    input   [3:0]   data_in,
    input           data_en,
    output reg [3:0] dataout
);

    // Register data and enable in clk_a domain
    reg [3:0] data_reg;
    reg       en_data_reg;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Two-stage synchronizer for enable signal from clk_a domain to clk_b domain
    reg en_sync_0, en_sync_1;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_0 <= 1'b0;
            en_sync_1 <= 1'b0;
        end else begin
            en_sync_0 <= en_data_reg;
            en_sync_1 <= en_sync_0;
        end
    end

    // Generate clock enable signal for output register from synchronized enable
    wire output_clk_enable;
    assign output_clk_enable = en_sync_1;

    // Output register updated only when output_clk_enable is high
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else if (output_clk_enable) begin
            dataout <= data_reg;
        end
        // else hold previous value (no update needed)
    end

endmodule