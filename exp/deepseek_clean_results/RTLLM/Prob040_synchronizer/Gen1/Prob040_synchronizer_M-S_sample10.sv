module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Single enable register in clk_a domain
    reg en_data_reg;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
        end
    end

    // Two-stage synchronizer for enable signal in clk_b domain
    reg [1:0] en_sync;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 2'b0;
        end else begin
            en_sync <= {en_sync[0], en_data_reg};
        end
    end

    // Output data assignment in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync[1]) begin
            dataout <= data_in;
        end
    end

endmodule