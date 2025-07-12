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
reg en_data_reg;
reg en_clap_one;
reg en_clap_two;

// Reset conditions
wire reset_a = ~arstn;
wire reset_b = ~brstn;

// Clock domain for clk_a
always @(posedge clk_a or posedge reset_a) begin
    if (reset_a) begin
        data_reg <= 0;
        en_data_reg <= 0;
    end else begin
        data_reg <= data_in;
        en_data_reg <= data_en;
    end
end

// Clock domain for clk_b
always @(posedge clk_b or posedge reset_b) begin
    if (reset_b) begin
        en_clap_one <= 0;
        en_clap_two <= 0;
        dataout <= 0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
        if (en_clap_two) begin
            dataout <= data_reg;
        end
    end
end

endmodule