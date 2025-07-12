module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Input data register in clk_a domain
    reg [3:0] data_reg;
    always @(posedge clk_a or negedge arstn)
        if (!arstn) data_reg <= 4'b0;
        else if (data_en) data_reg <= data_in;

    // Two-stage synchronizer with shared reset
    reg [1:0] en_sync;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 2'b0;
            dataout <= 4'b0;
        end
        else begin
            en_sync <= {en_sync[0], data_en};
            // Clock gating implementation
            if (en_sync[1]) dataout <= data_reg;
        end
    end

endmodule