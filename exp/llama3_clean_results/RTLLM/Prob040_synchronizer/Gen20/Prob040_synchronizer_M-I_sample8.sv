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
reg en_data_reg;
reg en_clap_one;
reg en_clap_two;
reg prev_en_data_reg;

// Data capture
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        en_data_reg <= 1'b0;
        prev_en_data_reg <= 1'b0;
    end else if (data_en && !prev_en_data_reg) begin
        data_reg <= data_in;
        en_data_reg <= 1'b1;
    end else if (!data_en) begin
        en_data_reg <= 1'b0;
    end
    prev_en_data_reg <= en_data_reg;
end

// Enable control registers
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Output assignment
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (en_clap_two) begin
        dataout <= data_reg;
    end
end

endmodule