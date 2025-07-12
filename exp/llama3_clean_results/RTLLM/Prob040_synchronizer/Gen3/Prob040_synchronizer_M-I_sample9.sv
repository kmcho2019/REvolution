module synchronizer(
    input  clk_a,
    input  clk_b,
    input  arstn,
    input  brstn,
    input  [3:0] data_in,
    input  data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg;
reg       en_data_reg;
reg       en_clap_one;
reg       en_clap_two;
reg [3:0] dataout_reg;
reg       clk_a_en; // Clock enable for clk_a domain
reg       clk_b_en; // Clock enable for clk_b domain

// Use continuous assignment for direct connections
assign dataout = dataout_reg;

// Clock gating logic
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        clk_a_en <= 1'd0;
    end else if (data_in!= data_reg || data_en!= en_data_reg) begin
        clk_a_en <= 1'd1;
    end else begin
        clk_a_en <= 1'd0;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        clk_b_en <= 1'd0;
    end else if (en_clap_two) begin
        clk_b_en <= 1'd1;
    end else begin
        clk_b_en <= 1'd0;
    end
end

// Conditional updates based on clock enables
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg     <= 4'd0;
        en_data_reg  <= 1'd0;
    end else if (clk_a_en) begin
        data_reg     <= data_in;
        en_data_reg  <= data_en;
    end
end

always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        en_clap_one  <= 1'd0;
        en_clap_two  <= 1'd0;
        dataout_reg  <= 4'd0;
    end else if (clk_b_en) begin
        en_clap_one  <= en_data_reg;
        en_clap_two  <= en_clap_one;
        if (en_clap_two) begin
            dataout_reg  <= data_reg;
        end
    end
end

endmodule