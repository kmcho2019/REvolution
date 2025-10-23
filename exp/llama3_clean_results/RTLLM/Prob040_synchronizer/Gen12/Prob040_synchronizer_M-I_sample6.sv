module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg; // Data register
reg data_en_reg; // Enable register
reg [1:0] en_delay; // Delayed enable signal

// Update data register and enable register on clk_a
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        data_en_reg <= 1'b0;
    end else begin
        if (data_en) begin
            data_reg <= data_in;
        end
        data_en_reg <= data_en;
    end
end

// Update en_delay and dataout on clk_b
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_delay <= 2'd0;
        dataout <= 4'd0;
    end else begin
        en_delay <= {en_delay[0], data_en_reg};
        if (en_delay[1]) begin
            dataout <= data_reg;
        end
    end
end

endmodule