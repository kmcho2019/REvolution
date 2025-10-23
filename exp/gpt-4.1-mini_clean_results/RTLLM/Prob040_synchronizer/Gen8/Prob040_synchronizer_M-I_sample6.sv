module synchronizer (
    input             clk_a,
    input             clk_b,
    input             arstn,
    input             brstn,
    input      [3:0]  data_in,
    input             data_en,
    output reg [3:0]  dataout
);

    // Registers in clk_a domain to latch input data and enable only when data_en is high
    reg [3:0] data_reg;
    reg       en_reg;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'd0;
            en_reg   <= 1'b0;
        end else if (data_en) begin
            data_reg <= data_in;
            en_reg   <= data_en;
        end
        // hold values otherwise to reduce switching
    end

    // Two-stage synchronizer for enable signal in clk_b domain using a shift register
    reg [1:0] en_sync;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            en_sync <= 2'b00;
        else
            en_sync <= {en_sync[0], en_reg};
    end

    wire en_clap_two = en_sync[1];

    // Output register update controlled by synchronized enable
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            dataout <= 4'd0;
        else if (en_clap_two)
            dataout <= data_reg;
        // else retain previous dataout
    end

endmodule