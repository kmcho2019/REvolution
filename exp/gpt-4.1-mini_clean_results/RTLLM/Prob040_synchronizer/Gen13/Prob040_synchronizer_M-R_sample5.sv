module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset active low, clk_a domain
    input  wire        brstn,      // async reset active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain registers
    reg [3:0] data_reg;
    reg       en_data_reg;

    // clk_b domain enable synchronizer registers
    reg en_clap_one, en_clap_two;

    // clk_a domain: latch data_in when data_en is high, or reset to 0 on arstn low
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            if (data_en) begin
                data_reg    <= data_in;
                en_data_reg <= 1'b1;
            end else begin
                en_data_reg <= 1'b0;
            end
        end
    end

    // clk_b domain: two stage synchronizer for en_data_reg crossing clock domain, async reset brstn
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // clk_b domain: output data latch with async reset brstn
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else begin
            dataout <= en_clap_two ? data_reg : dataout;
        end
    end

endmodule