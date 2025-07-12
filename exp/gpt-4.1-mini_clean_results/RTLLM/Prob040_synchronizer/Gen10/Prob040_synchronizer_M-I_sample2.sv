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
    reg [3:0] data_reg;      // latch input data when data_en is high
    reg       en_data_reg;   // latched data_en for synchronization

    // Registers in clk_b domain for two-stage enable synchronization
    reg en_clap_one, en_clap_two;

    // Data register in clk_b domain capturing stable data from clk_a domain
    reg [3:0] data_sync;

    // clk_a domain: latch data_reg only when data_en is high; latch en_data_reg every cycle
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
            if (data_en)
                data_reg <= data_in;
            // else hold previous data_reg
        end
    end

    // clk_b domain: two-stage synchronizer on en_data_reg and conditional data latch/output
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
            data_sync   <= 4'd0;
            dataout     <= 4'd0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;

            if (en_clap_two) begin
                data_sync <= data_reg;
                dataout   <= data_sync;
            end
            // else retain previous data_sync and dataout
        end
    end

endmodule