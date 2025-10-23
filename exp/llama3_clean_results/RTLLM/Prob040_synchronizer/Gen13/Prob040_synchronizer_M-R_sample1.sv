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
reg en_delay1;
reg en_delay2;

// Update data register on clk_a
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
    end else if (data_en) begin
        data_reg <= data_in;
    end
end

// Delay data_en by two clk_b cycles
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_delay1 <= 1'b0;
        en_delay2 <= 1'b0;
    end else begin
        en_delay1 <= data_en;
        en_delay2 <= en_delay1;
    end
end

// Assign output on clk_b
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (en_delay2) begin
        dataout <= data_reg;
    end
end

endmodule