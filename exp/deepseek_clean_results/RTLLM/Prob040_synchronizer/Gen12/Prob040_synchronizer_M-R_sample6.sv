module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data capture in clk_a domain
    reg [3:0] data_reg;
    reg en_data_reg;
    
    // Continuous assignment for data_reg with reset
    always @(posedge clk_a or negedge arstn)
        if (!arstn) data_reg <= 4'b0;
        else if (data_en) data_reg <= data_in;
    
    // Continuous assignment for enable register
    always @(posedge clk_a or negedge arstn)
        if (!arstn) en_data_reg <= 1'b0;
        else en_data_reg <= data_en;

    // Two-stage synchronizer in clk_b domain
    reg [1:0] en_sync;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 2'b00;
        end else begin
            en_sync <= {en_sync[0], en_data_reg};
        end
    end

    // Output assignment - only update when synchronized enable is high
    always @(posedge clk_b or negedge brstn)
        if (!brstn) dataout <= 4'b0;
        else if (en_sync[1]) dataout <= data_reg;

endmodule