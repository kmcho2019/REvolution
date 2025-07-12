module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,     // async active-low reset clk_a domain
    input  wire        brstn,     // sync active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;
    reg       en_data_reg;

    // Registers in clk_b domain for enable synchronization
    reg en_clap_one, en_clap_two;

    // Helper signals for clock enables
    wire en_data_reg_ce;
    wire en_sync_ce;

    // Determine when data_en or en_data_reg changes to enable updates
    // en_data_reg should update only on change or when data_en is high (to capture stable enables)
    assign en_data_reg_ce = (en_data_reg != data_en) || data_en;

    // en_clap_one updates only when en_data_reg changes (minimize toggling)
    assign en_sync_ce = (en_clap_one != en_data_reg);

    // clk_a domain: async reset, update en_data_reg and data_reg with clock enable gating
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            // update en_data_reg only when change or data_en high to reduce toggling
            if (en_data_reg_ce)
                en_data_reg <= data_en;

            // update data_reg only when data_en is high (per spec)
            if (data_en)
                data_reg <= data_in;
        end
    end

    // clk_b domain: 2-stage synchronizer for enable with clock enable gating
    always @(posedge clk_b) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            // update only when en_data_reg changes to reduce toggling
            if (en_sync_ce)
                en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // clk_b domain: output register update with synchronous reset,
    // update dataout only when enable is high, preserving previous otherwise
    always @(posedge clk_b) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_clap_two) begin
            dataout <= data_reg;
        end
        // else retain previous dataout
    end

endmodule