module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

// Data Register with Clock Gating
reg [3:0] data_reg;
reg clk_a_gated;
assign clk_a_gated = clk_a & data_en;
always @(posedge clk_a_gated or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
    end else begin
        data_reg <= data_in;
    end
end

// Enable Signal Delay Registers with Clock Gating
reg en_delay1;
reg en_delay2;
reg clk_b_gated;
assign clk_b_gated = clk_b & (data_en || en_delay1);
always @(posedge clk_b_gated or negedge brstn) begin
    if (!brstn) begin
        en_delay1 <= 1'b0;
        en_delay2 <= 1'b0;
    end else begin
        en_delay1 <= data_en;
        en_delay2 <= en_delay1;
    end
end

// Output Logic
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (en_delay2) begin
        dataout <= data_reg;
    end
end

endmodule