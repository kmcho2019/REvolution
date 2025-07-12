module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A signals
    reg [3:0] data_reg;
    reg en_data_reg;
    wire gated_clk_a = clk_a & (data_en | !arstn); // Clock gating for power savings

    // Clock domain B synchronization registers
    reg en_sync1, en_sync2;

    // Data capture in clk_a domain - gated clock implementation
    always @(posedge gated_clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end else begin
            data_reg <= data_in; // Only updates when gated clock is active
        end
    end

    // Enable register in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
        end
    end

    // Two-stage enable synchronization in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
            dataout <= 4'b0;
        end else begin
            en_sync1 <= en_data_reg;
            en_sync2 <= en_sync1;
            if (en_sync2) begin
                dataout <= data_reg;
            end
        end
    end

endmodule