module synchronizer (
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

// Data register to store input data_in, updated on clk_a and reset by arstn
reg [3:0] data_reg;
always @(posedge clk_a or negedge arstn) begin
    if (!arstn)
        data_reg <= 4'd0;
    else
        data_reg <= data_in;
end

// Enable data register, stores data_en signal on clk_a and reset by arstn
reg en_data_reg;
always @(posedge clk_a or negedge arstn) begin
    if (!arstn)
        en_data_reg <= 1'b0;
    else
        en_data_reg <= data_en;
end

// Enable control registers to delay en_data_reg by two clk_b cycles, reset by brstn
reg en_clap_one, en_clap_two;
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Output assignment controlled by en_clap_two on clk_b domain, reset by brstn
always @(posedge clk_b or negedge brstn) begin
    if (!brstn)
        dataout <= 4'd0;
    else if (en_clap_two)
        dataout <= data_reg;
    else
        dataout <= dataout; // hold previous value
end

endmodule