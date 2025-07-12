module synchronizer(
    input clk_a, 
    input clk_b, 
    input arstn, 
    input brstn, 
    input [3:0] data_in, 
    input data_en, 
    output [3:0] dataout
);

reg [3:0] data_reg;
reg en_data_reg;
reg en_clap_one;
reg en_clap_two;

// Data Register
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 0;
    end else begin
        data_reg <= data_in;
    end
end

// Enable Data Register
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        en_data_reg <= 0;
    end else begin
        en_data_reg <= data_en;
    end
end

// Enable Control Registers
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 0;
        en_clap_two <= 0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Output Assignment
reg [3:0] dataout_reg;
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout_reg <= 0;
    end else if (en_clap_two) begin
        dataout_reg <= data_reg;
    end
end

assign dataout = dataout_reg;

endmodule