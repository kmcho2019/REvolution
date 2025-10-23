module en_sync(
    input        clk_b,
    input        brstn,
    input        en_in,
    output reg   en_sync_out
);
    reg en_ff1;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_ff1      <= 1'b0;
            en_sync_out <= 1'b0;
        end else begin
            en_ff1      <= en_in;
            en_sync_out <= en_ff1;
        end
    end
endmodule

module synchronizer(
    input             clk_a,
    input             clk_b,
    input             arstn,      // active low async reset clk_a domain
    input             brstn,      // active low async reset clk_b domain
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

    // clk_a domain registers
    reg [3:0] data_reg;
    reg       en_data_reg;

    // Capture data_in only when data_en is high, capture data_en every clk_a cycle
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

    // Enable synchronizer crossing to clk_b domain
    wire en_clap_two;

    en_sync en_sync_inst (
        .clk_b(clk_b),
        .brstn(brstn),
        .en_in(en_data_reg),
        .en_sync_out(en_clap_two)
    );

    // Mux dataout update on clk_b domain using synchronized enable
    wire [3:0] mux_dataout = en_clap_two ? data_reg : dataout;

    // Output register updated on clk_b with async reset
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            dataout <= 4'd0;
        else
            dataout <= mux_dataout;
    end

endmodule