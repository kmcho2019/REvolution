module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Combined data and enable register in clk_a domain
    reg [4:0] data_en_reg; // [3:0] data, [4] enable
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_en_reg <= 5'b0;
        end else begin
            data_en_reg <= {data_en, data_in};
        end
    end

    // Two-stage synchronizer in clk_b domain
    reg [1:0] en_sync;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 2'b0;
        end else begin
            en_sync <= {en_sync[0], data_en_reg[4]};
        end
    end

    // Optimized output register with conditional update
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync[1]) begin
            dataout <= data_en_reg[3:0];
        end
    end

endmodule