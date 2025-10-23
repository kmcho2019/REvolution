module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active low reset (clk_a domain), synchronous reset now
    input  wire        brstn,      // active low reset (clk_b domain), synchronous reset
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;      // stores data_in when data_en is high
    reg       en_data_reg;   // captures data_en every clk_a cycle

    // Registers in clk_b domain for enable synchronization (2-stage)
    reg en_clap_one, en_clap_two;

    // Edge detect enable pulse in clk_b domain
    reg en_clap_two_d;       // delayed version of en_clap_two
    wire en_pulse = en_clap_two & ~en_clap_two_d; // rising edge detect

    // Intermediate data register in clk_b domain to hold synchronized data
    reg [3:0] data_sync;

    // clk_a domain: synchronous reset; capture data_en every cycle;
    // update data_reg only when data_en is high to reduce toggling
    always @(posedge clk_a) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
            if (data_en)
                data_reg <= data_in;
        end
    end

    // clk_b domain: synchronous reset; two-stage synchronizer for enable
    always @(posedge clk_b) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
            en_clap_two_d <= 1'b0;
            data_sync <= 4'd0;
            dataout <= 4'd0;
        end else begin
            // Two-stage enable synchronizer
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;

            // Edge detect enable pulse
            en_clap_two_d <= en_clap_two;

            // Latch data_sync only on rising edge of synchronized enable
            if (en_pulse) begin
                data_sync <= data_reg;
            end

            // Update output dataout from data_sync every clk_b cycle, or optionally only when data_sync updated
            // Here we update output every cycle to simplify logic and ensure output stable
            dataout <= data_sync;
        end
    end

endmodule