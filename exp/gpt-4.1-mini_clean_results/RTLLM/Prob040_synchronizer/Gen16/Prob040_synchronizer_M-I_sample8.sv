module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // sync reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain with clock enable
    reg [3:0] data_reg;
    reg       en_data_reg;

    // Clock gating signal: enable data_reg and en_data_reg update only when data_en is high or during reset
    wire clk_a_ce = data_en | (~arstn);

    // Two-stage synchronizer for enable in clk_b domain
    reg en_clap_one, en_clap_two;
    reg en_clap_two_d;  // Delayed en_clap_two for edge detection

    // clk_a domain: async reset; update registers on posedge clk_a with clock enable
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else if (clk_a_ce) begin
            en_data_reg <= data_en;
            if (data_en)
                data_reg <= data_in;
        end
        // else hold previous values, no toggle
    end

    // clk_b domain: synchronous reset; two-stage enable synchronizer; update dataout on enable rising edge
    always @(posedge clk_b) begin
        if (!brstn) begin
            en_clap_one  <= 1'b0;
            en_clap_two  <= 1'b0;
            en_clap_two_d <= 1'b0;
            dataout      <= 4'd0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
            en_clap_two_d <= en_clap_two;

            // Detect rising edge of synchronized enable
            if (~en_clap_two_d & en_clap_two)
                dataout <= data_reg;
            // else keep previous dataout stable to reduce toggling
        end
    end

endmodule