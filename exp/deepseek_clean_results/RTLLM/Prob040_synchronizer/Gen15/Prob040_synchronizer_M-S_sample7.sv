module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // clk_a domain signals
    reg [3:0] data_reg;
    
    // clk_b domain signals
    reg [1:0] en_sync_b;

    // Register input data in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end else if (data_en) begin
            data_reg <= data_in;
        end
    end

    // Synchronize enable to clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_b <= 2'b0;
        end else begin
            en_sync_b <= {en_sync_b[0], data_en};
        end
    end

    // Update output when synchronized enable is active
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync_b[1]) begin
            dataout <= data_reg;
        end
    end

endmodule