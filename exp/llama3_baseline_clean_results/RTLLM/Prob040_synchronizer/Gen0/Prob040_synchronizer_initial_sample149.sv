module synchronizer(
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg;
reg data_en_reg;
reg en_clap_one;
reg en_clap_two;

// Update data register on the positive edge of clock A or the falling edge of reset A
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_reg <= 4'd0;
    end else begin
        data_reg <= data_in;
    end
end

// Update enable register on the positive edge of clock A or the falling edge of reset A
always @(posedge clk_a or negedge arstn) begin
    if (~arstn) begin
        data_en_reg <= 1'd0;
    end else begin
        data_en_reg <= data_en;
    end
end

// Update enable control registers on the positive edge of clock B or the falling edge of reset B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        en_clap_one <= 1'd0;
        en_clap_two <= 1'd0;
    end else begin
        en_clap_one <= data_en_reg;
        en_clap_two <= en_clap_one;
    end
end

// Assign output data value on the positive edge of clock B or the falling edge of reset B
always @(posedge clk_b or negedge brstn) begin
    if (~brstn) begin
        dataout <= 4'd0;
    end else if (en_clap_two) begin
        dataout <= data_reg;
    end else begin
        // Retain previous value if en_clap_two is inactive
    end
end

endmodule