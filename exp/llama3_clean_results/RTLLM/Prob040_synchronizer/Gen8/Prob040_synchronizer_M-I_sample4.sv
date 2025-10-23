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
reg [3:0] data_buf;

// Data Register
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg <= 4'd0;
    end else if (data_en) begin
        data_reg <= data_in;
    end
end

// Synchronizer
reg data_en_b;
reg data_en_b_d1;
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        data_en_b <= 1'd0;
        data_en_b_d1 <= 1'd0;
    end else begin
        data_en_b <= data_en;
        data_en_b_d1 <= data_en_b;
    end
end

// Output Controller
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout <= 4'd0;
        data_buf <= 4'd0;
    end else if (data_en_b_d1) begin
        data_buf <= data_reg;
        dataout <= data_buf;
    end else begin
        dataout <= dataout;
    end
end

endmodule