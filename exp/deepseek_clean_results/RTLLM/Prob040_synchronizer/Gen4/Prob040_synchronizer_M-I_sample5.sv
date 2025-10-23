module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A registers
    reg [3:0] data_reg;
    reg en_data_reg;
    
    // Clock domain B registers
    reg [1:0] en_sync; // {en_clap_two, en_clap_one}
    
    // Data path in clk_a domain - only update when enabled
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else if (data_en) begin // Only update when enabled
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end
    
    // Enable synchronization in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 2'b00;
        end else begin
            en_sync <= {en_sync[0], en_data_reg};
        end
    end
    
    // Output assignment with clock gating behavior
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync[1]) begin // Only update when synchronized enable is high
            dataout <= data_reg;
        end
    end

endmodule