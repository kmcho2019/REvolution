module en_sync(
    input        clk_b,
    input        brstn,
    input        en_in,
    output reg   en_sync_out
);
    reg en_ff1;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_ff1 <= 1'b0;
            en_sync_out <= 1'b0;
        end else begin
            en_ff1 <= en_in;
            en_sync_out <= en_ff1;
        end
    end
endmodule

module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // async reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;
    reg       en_data_reg;

    // clk_a domain: async reset; update data_reg only when data_en is asserted
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

    // Instantiate enable synchronizer module crossing to clk_b domain
    wire en_clap_two;
    en_sync en_sync_inst (
        .clk_b(clk_b),
        .brstn(brstn),
        .en_in(en_data_reg),
        .en_sync_out(en_clap_two)
    );

    // Combinational mux selects data_reg or current dataout based on synchronized enable
    wire [3:0] mux_dataout = en_clap_two ? data_reg : dataout;

    // clk_b domain: async reset; update output data register
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            dataout <= 4'd0;
        else
            dataout <= mux_dataout;
    end

endmodule