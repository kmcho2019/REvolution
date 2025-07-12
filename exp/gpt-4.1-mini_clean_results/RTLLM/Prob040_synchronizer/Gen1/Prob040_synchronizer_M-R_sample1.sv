module synchronizer (
    input               clk_a,
    input               clk_b,
    input               arstn,
    input               brstn,
    input       [3:0]   data_in,
    input               data_en,
    output reg  [3:0]   dataout
);

    reg [3:0] data_reg;
    reg       en_data_reg;
    reg       en_clap_one, en_clap_two;

    // Data and enable registers in clk_a domain with async active-low reset arstn
    // Only update data_reg when data_en is asserted to reduce unnecessary toggling
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
            if (data_en)
                data_reg <= data_in;
        end
    end

    // Combine enable pipeline and output data update in clk_b domain with async active-low reset brstn
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
            dataout     <= 4'd0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;

            // Update dataout only when en_clap_two is asserted (clock enable)
            if (en_clap_two)
                dataout <= data_reg;
            // else dataout holds its value implicitly
        end
    end

endmodule