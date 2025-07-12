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
reg       en_clap_one;
reg       en_clap_two;

// Generate req signal in clock domain A
assign req_a = data_en;

// Synchronize req signal from clock domain A to clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        req_b <= 1'b0;
    end else begin
        req_b <= req_a;
    end
end

// Update data_reg in clock domain A
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg <= data_en ? data_in : data_reg;
        en_data_reg <= data_en;
    end
end

// Update enable control registers in clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= req_b;
        en_clap_two <= en_clap_one;
    end
end

// Update dataout_reg in clock domain B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout_reg <= 4'b0;
    end else if (en_clap_two) begin
        dataout_reg <= data_reg;
    end else begin
        dataout_reg <= dataout_reg;
    end
end

assign dataout = dataout_reg;

endmodule