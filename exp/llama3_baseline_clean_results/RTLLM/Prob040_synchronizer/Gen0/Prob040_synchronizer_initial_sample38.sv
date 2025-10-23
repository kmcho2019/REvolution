module synchronizer(
    input  clk_a,
    input  clk_b,
    input  arstn,
    input  brstn,
    input  [3:0] data_in,
    input  data_en,
    output [3:0] dataout
);

// Data Register
reg [3:0] data_reg;
always @(posedge clk_a, negedge arstn) begin
    if (~arstn) begin
        data_reg <= 4'd0;
    end else begin
        data_reg <= data_in;
    end
end

// Enable Data Register
reg enable_reg;
always @(posedge clk_a, negedge arstn) begin
    if (~arstn) begin
        enable_reg <= 1'b0;
    end else begin
        enable_reg <= data_en;
    end
end

// Enable Control Registers
reg en_clap_one;
reg en_clap_two;
always @(posedge clk_b, negedge brstn) begin
    if (~brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= enable_reg;
        en_clap_two <= en_clap_one;
    end
end

// Output Assignment
reg [3:0] dataout_reg;
always @(posedge clk_b, negedge brstn) begin
    if (~brstn) begin
        dataout_reg <= 4'd0;
    end else if (en_clap_two) begin
        dataout_reg <= data_reg;
    end else begin
        dataout_reg <= dataout_reg;
    end
end
assign dataout = dataout_reg;

endmodule