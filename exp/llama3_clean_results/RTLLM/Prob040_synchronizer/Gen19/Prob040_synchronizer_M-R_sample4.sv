module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg;
reg [1:0] en_reg;

// Data capture
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
    end else if (data_en) begin
        data_reg <= data_in;
    end
end

// Enable control
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_reg <= 2'b00;
    end else begin
        en_reg <= {en_reg[0], data_en};
    end
end

// Output assignment
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (en_reg[1]) begin
        dataout <= data_reg;
    end
end

endmodule