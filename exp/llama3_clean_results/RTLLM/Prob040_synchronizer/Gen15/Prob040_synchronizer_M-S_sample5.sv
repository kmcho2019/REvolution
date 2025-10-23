module synchronizer (
    input clk_a,
    input clk_b,
    input arstn,
    input brstn,
    input [3:0] data_in,
    input data_en,
    output reg [3:0] dataout
);

reg [3:0] data_reg; // Register to store data_in
reg data_en_reg; // Register to store data_en
reg en_clap_one; // First enable signal delay
reg en_clap_two; // Second enable signal delay

// Clock domain crossing for data_in and data_en
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'd0;
        data_en_reg <= 1'd0;
    end else if (data_en) begin
        data_reg <= data_in;
        data_en_reg <= data_en;
    end
end

// Delay enable signal by two clk_b cycles and assign output dataout
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'd0;
        en_clap_two <= 1'd0;
        dataout <= 4'd0;
    end else begin
        en_clap_one <= data_en_reg;
        en_clap_two <= en_clap_one;
        if (en_clap_two) begin
            dataout <= data_reg;
        end
    end
end

endmodule