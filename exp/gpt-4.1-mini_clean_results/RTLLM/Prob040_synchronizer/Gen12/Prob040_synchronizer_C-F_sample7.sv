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
    reg [3:0] data_reg;      // stores data_in when data_en is high
    reg       en_data_reg;   // registers data_en every clk_a cycle for synchronization

    // Registers in clk_b domain: two-stage synchronization of en_data_reg
    reg en_clap_one, en_clap_two;

    // Intermediate data register in clk_b domain to hold synchronized data
    reg [3:0] data_sync;

    // clk_a domain: asynchronous reset, latch en_data_reg every cycle, update data_reg only when data_en is asserted
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

    // clk_b domain: synchronous reset, two-stage enable synchronization, conditional data and output updates
    always @(posedge clk_b) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
            data_sync   <= 4'd0;
            dataout     <= 4'd0;
        end else begin
            // Two-stage synchronization of enable signal
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;

            // Update synchronized data and output only when enable is asserted after synchronization
            if (en_clap_two) begin
                data_sync <= data_reg;
                dataout   <= data_sync;
            end
            // else retain previous data_sync and dataout
        end
    end

endmodule