module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data register in clk_a domain
    reg [3:0] data_reg;

    // Enable synchronization registers in clk_b domain
    reg [1:0] en_sync;

    // Data capture in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end else if (data_en) begin
            data_reg <= data_in;
        end
    end

    // Enable sync and data output in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 2'b0;
            dataout <= 4'b0;
        end else begin
            en_sync <= {en_sync[0], data_en};
            if (en_sync[1]) begin
                dataout <= data_reg;
            end
        end
    end

endmodule