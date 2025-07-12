module synchronizer (
    input           clk_a,
    input           clk_b,
    input           arstn,
    input           brstn,
    input   [3:0]   data_in,
    input           data_en,
    output  [3:0]   dataout
);

reg [3:0] data_reg;
reg       req_a;
reg       req_b;
reg [3:0] dataout_reg;
reg       en_data_reg;
reg       en_clap;

// Generate req signal in clock domain A
assign req_a = data_en;

// Update data_reg in clock domain A
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg <= 4'b0;
        en_data_reg <= 1'b0;
        req_b <= 1'b0;
    end else begin
        data_reg <= data_en ? data_in : data_reg;
        en_data_reg <= data_en;
        req_b <= req_a;
    end
end

// Update enable control register and dataout_reg in clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        en_clap <= 1'b0;
        dataout_reg <= 4'b0;
    end else begin
        en_clap <= req_b;
        if (en_clap) begin
            dataout_reg <= data_reg;
        end else begin
            dataout_reg <= dataout_reg;
        end
    end
end

assign dataout = dataout_reg;

endmodule