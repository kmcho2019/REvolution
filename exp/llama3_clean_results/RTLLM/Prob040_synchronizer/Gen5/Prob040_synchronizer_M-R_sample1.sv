module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

// Data Register
reg [3:0] data_reg;
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg <= 4'd0;
    end else if (data_en) begin
        data_reg <= data_in;
    end else begin
        data_reg <= data_reg;
    end
end

// Enable Data Register
reg data_en_reg;
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_en_reg <= 1'd0;
    end else begin
        data_en_reg <= data_en;
    end
end

// Enable Control Registers
reg [1:0] en_clk_b;
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        en_clk_b <= 2'd0;
    end else begin
        en_clk_b <= {en_clk_b[0], data_en_reg};
    end
end

// Output Assignment
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout <= 4'd0;
    end else if (en_clk_b[1]) begin
        dataout <= data_reg;
    end else begin
        dataout <= dataout;
    end
end

endmodule