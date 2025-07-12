module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // sync reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;
    reg       en_data_reg;

    // Enable synchronizer shift register (2 stages) in clk_b domain
    reg [1:0] en_sync;

    // clk_a domain: asynchronous reset; update data_reg and en_data_reg only when needed
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            // Update en_data_reg only if changed to reduce toggling
            if (en_data_reg != data_en)
                en_data_reg <= data_en;

            // Update data_reg only if data_en is high
            if (data_en)
                data_reg <= data_in;
        end
    end

    // clk_b domain: synchronous reset; synchronize enable; update dataout when enable asserted
    always @(posedge clk_b) begin
        if (!brstn) begin
            en_sync <= 2'b00;
            dataout <= 4'd0;
        end else begin
            en_sync <= {en_sync[0], en_data_reg};
            if (en_sync[1])
                dataout <= data_reg;
            // else retain previous dataout
        end
    end

endmodule