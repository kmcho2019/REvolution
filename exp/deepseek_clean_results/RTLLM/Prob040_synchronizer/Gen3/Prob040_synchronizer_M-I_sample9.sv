module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data register in clk_a domain with clock gating
    reg [3:0] data_reg;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end else if (data_en) begin  // Only update when enabled
            data_reg <= data_in;
        end
    end

    // Enable register in clk_a domain
    reg en_data_reg;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
        end
    end

    // Combined two-stage synchronizer in clk_b domain
    reg [1:0] sync_chain;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            sync_chain <= 2'b00;
        end else begin
            sync_chain <= {sync_chain[0], en_data_reg};
        end
    end

    // Enable-based output assignment in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (sync_chain[1]) begin  // Only update when synchronized enable is high
            dataout <= data_reg;
        end
    end

endmodule