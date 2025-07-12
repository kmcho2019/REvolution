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
reg pulse;

// Data register
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
    end else begin
        data_reg <= data_in;
    end
end

// Enable register
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        en_data_reg <= 1'd0;
    end else begin
        en_data_reg <= data_en;
    end
end

// Pulse generator
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        pulse <= 1'd0;
    end else if (en_data_reg) begin
        pulse <= ~pulse;
    end else begin
        pulse <= 1'd0;
    end
end

// Enable control registers
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'd0;
        en_clap_two <= 1'd0;
    end else begin
        en_clap_one <= pulse;
        en_clap_two <= en_clap_one;
    end
end

// Output assignment
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (en_clap_two) begin
        dataout <= data_reg;
    end else begin
        dataout <= dataout;
    end
end

endmodule