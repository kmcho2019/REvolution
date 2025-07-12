module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg; // Data register clocked by clk_a
reg en_data_reg; // Register for data_en
reg en_sync; // Synchronized enable signal

// Sequential logic for data capture
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        en_data_reg <= 1'd0;
    end else begin
        data_reg <= data_in;
        en_data_reg <= data_en;
    end
end

// Enable synchronization and output assignment
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_sync <= 1'd0;
        dataout <= 4'd0;
    end else begin
        en_sync <= en_data_reg;
        if (en_sync) begin
            dataout <= data_reg;
        end
    end
end

endmodule