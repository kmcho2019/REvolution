module synchronizer (
    input         clk_a,
    input         clk_b,
    input         arstn,
    input         brstn,
    input  [3:0]  data_in,
    input         data_en,
    output reg [3:0] dataout
);

// Registers in clk_a domain
reg [3:0] data_reg;
reg       en_data_reg;

// Registers in clk_b domain (enable signal delayed by two clock cycles)
reg en_clap_one, en_clap_two;

// clk_a domain: capture data_in and data_en with asynchronous reset
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg    <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg    <= data_in;
        en_data_reg <= data_en;
    end
end

// clk_b domain: two flip-flops to delay en_data_reg signal synchronously to clk_b
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// clk_b domain: output assignment using MUX-based selection based on en_clap_two
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0;
    end else if (en_clap_two) begin
        dataout <= data_reg;
    end else begin
        dataout <= dataout;
    end
end

endmodule