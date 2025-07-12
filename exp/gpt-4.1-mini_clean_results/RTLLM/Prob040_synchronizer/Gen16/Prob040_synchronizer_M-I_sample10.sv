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
    reg en_clap_one, en_clap_two;

    // clk_a domain: asynchronous reset, update en_data_reg only on change,
    // and update data_reg only when data_en is high to reduce toggling
    reg data_en_d; // delayed data_en for change detection
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
            data_en_d   <= 1'b0;
        end else begin
            data_en_d <= data_en;
            // Update en_data_reg only if data_en changed
            if (data_en != data_en_d)
                en_data_reg <= data_en;
            if (data_en)
                data_reg <= data_in;
        end
    end

    // clk_b domain: asynchronous reset, merge enable sync and output update
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
            dataout     <= 4'd0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
            // Update dataout only when en_clap_two is active to reduce toggling
            if (en_clap_two)
                dataout <= data_reg;
            // else retain previous dataout value
        end
    end

endmodule