module synchronizer(
    input        clk_a,
    input        clk_b,
    input        arstn,
    input        brstn,
    input  [3:0]  data_in,
    input        data_en,
    output [3:0] dataout
);

reg [3:0] data_reg;
reg        en_data_reg;
reg        en_clap_one;
reg        en_clap_two;

// Update data_reg and en_data_reg on the positive edge of clk_a or the falling edge of arstn
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg    <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg    <= data_in;
        en_data_reg <= data_en;
    end
end

// Update en_clap_one and en_clap_two on the positive edge of clk_b or the falling edge of brstn
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Assign output dataout on the positive edge of clk_b or the falling edge of brstn
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout <= 4'b0;
    end else if (en_clap_two) begin
        dataout <= data_reg;
    end
end

endmodule