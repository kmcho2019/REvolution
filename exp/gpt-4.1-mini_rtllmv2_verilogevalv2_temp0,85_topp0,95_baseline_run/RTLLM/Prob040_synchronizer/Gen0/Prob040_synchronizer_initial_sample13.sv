module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,    // async reset active low clk_a domain
    input  wire        brstn,    // async reset active low clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

// Registers in clk_a domain
reg [3:0] data_reg;
reg       en_data_reg;

// Registers in clk_b domain for enable synchronization and delay
reg en_clap_one;
reg en_clap_two;

// Data and enable register update on clk_a domain
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg    <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg    <= data_in;
        en_data_reg <= data_en;
    end
end

// Enable signal delay registers on clk_b domain
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Output data update on clk_b domain
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0;
    end else begin
        if (en_clap_two)
            dataout <= data_reg;
        else
            dataout <= dataout;
    end
end

endmodule