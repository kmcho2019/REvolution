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
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg    <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Combined enable control registers and output update in clk_b domain with async active-low reset brstn
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
            dataout     <= 4'd0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;

            if (en_clap_two) begin
                dataout <= data_reg;
            end
            // else retain previous dataout value implicitly by no assignment
        end
    end

endmodule