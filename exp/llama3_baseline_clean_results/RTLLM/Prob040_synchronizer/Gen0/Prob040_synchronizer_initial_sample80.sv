module synchronizer(
    input        clk_a,
    input        clk_b,
    input        arstn,
    input        brstn,
    input  [3:0] data_in,
    input        data_en,
    output [3:0] dataout
);

reg [3:0] data_reg;
reg       en_data_reg;
reg       en_clap_one;
reg       en_clap_two;
reg [3:0] dataout_reg;

always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg <= 4'd0;
        en_data_reg <= 1'd0;
    end else begin
        data_reg <= data_in;
        en_data_reg <= data_en;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        en_clap_one <= 1'd0;
        en_clap_two <= 1'd0;
        dataout_reg <= 4'd0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
        if (en_clap_two) begin
            dataout_reg <= data_reg;
        end else begin
            dataout_reg <= dataout_reg;
        end
    end
end

assign dataout = dataout_reg;

endmodule