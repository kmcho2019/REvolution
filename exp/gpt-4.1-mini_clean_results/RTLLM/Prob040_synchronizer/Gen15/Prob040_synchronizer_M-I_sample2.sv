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
    reg [3:0] data_reg;       // stores stable input data, latched on rising edge of data_en
    reg       en_data_reg;    // synchronized enable, updated on rising edge of data_en only
    reg       data_en_d;      // delayed version of data_en to detect rising edge

    // Registers in clk_b domain: two-stage synchronization of en_data_reg
    reg en_clap_one, en_clap_two;

    // Previous value of en_clap_two to detect rising edge
    reg en_clap_two_d;

    // Intermediate data register in clk_b domain to hold synchronized data
    reg [3:0] data_sync;

    // ---- clk_a domain logic ----
    // Asynchronous reset, latch data_reg and en_data_reg only on rising edge of data_en to reduce toggling
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
            data_en_d   <= 1'b0;
        end else begin
            data_en_d <= data_en;
            if (~data_en_d & data_en) begin
                // rising edge of data_en
                data_reg    <= data_in;     // latch stable data once per data_en assertion
                en_data_reg <= 1'b1;
            end else if (data_en == 1'b0) begin
                // when data_en is low, clear en_data_reg to zero to reflect disable
                en_data_reg <= 1'b0;
            end
            // else hold previous values to avoid unnecessary toggling
        end
    end

    // ---- clk_b domain logic ----
    always @(posedge clk_b) begin
        if (!brstn) begin
            en_clap_one   <= 1'b0;
            en_clap_two   <= 1'b0;
            en_clap_two_d <= 1'b0;
            data_sync     <= 4'd0;
            dataout       <= 4'd0;
        end else begin
            // Two-stage synchronization of enable signal
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;

            // Edge detect on en_clap_two rising edge to update data only once per enable assertion
            en_clap_two_d <= en_clap_two;
            if (en_clap_two & ~en_clap_two_d) begin
                data_sync <= data_reg;
                dataout   <= data_reg;
            end
            // else hold previous data_sync and dataout to reduce toggling
        end
    end

endmodule