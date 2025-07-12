module synchronizer(
    input             clk_a,
    input             arstn,
    input             clk_b,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

reg [3:0] data_reg;
reg       en_data_reg;
reg       en_clap_one, en_clap_two;

// Capture data_in on clk_a domain only when data_en is high
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        en_data_reg <= 1'b0;
    end else begin
        en_data_reg <= data_en;
        if (data_en)
            data_reg <= data_in;
    end
end

// Synchronize en_data_reg into clk_b domain with two flip-flops (shift register style)
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Output data update using mux-style assignment in always block
always @(posedge clk_b or negedge brstn) begin
    if (!brstn)
        dataout <= 4'd0;
    else
        dataout <= en_clap_two ? data_reg : dataout;
end

endmodule