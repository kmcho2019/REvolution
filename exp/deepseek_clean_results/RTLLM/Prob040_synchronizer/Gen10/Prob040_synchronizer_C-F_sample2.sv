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
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end else if (data_en) begin
            data_reg <= data_in;
        end
    end

    // Two-stage enable synchronizer in clk_b domain
    reg [1:0] en_sync;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 2'b00;
        end else begin
            en_sync <= {en_sync[0], data_en};
        end
    end

    // Output data register with conditional update
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync[1]) begin
            dataout <= data_reg;
        end
    end

endmodule