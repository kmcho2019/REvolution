module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // async reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain registers
    reg [3:0] data_reg;
    reg       en_data_reg;

    // clk_b domain registers for enable synchronization
    reg en_clap_one;
    reg en_clap_two;

    // clk_a domain: async reset, latch data_in to data_reg only when data_en is high,
    // latch data_en to en_data_reg every clk_a rising edge
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            if (data_en)
                data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // clk_b domain: async reset, two-stage synchronizer for en_data_reg crossing clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // clk_b domain: async reset, update dataout when en_clap_two is asserted,
    // hold previous value otherwise
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else if (en_clap_two) begin
            dataout <= data_reg;
        end
    end

endmodule