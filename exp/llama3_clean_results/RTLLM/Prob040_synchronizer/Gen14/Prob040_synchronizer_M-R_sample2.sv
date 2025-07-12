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
reg data_en_reg;
reg data_en_delayed;

// Clock domain crossing for data_in and data_en
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        data_en_reg <= 1'd0;
    end else begin
        data_reg <= data_en? data_in : data_reg;
        data_en_reg <= data_en;
    end
end

// Delay enable signal by two clk_b cycles
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        data_en_delayed <= 1'd0;
    end else begin
        data_en_delayed <= data_en_reg;
    end
end

// Assign output dataout based on delayed enable signal
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (data_en_delayed) begin
        dataout <= data_reg;
    end
end

endmodule