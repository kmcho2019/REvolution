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

    // Enable synchronization registers in clk_b domain
    reg en_clap_one, en_clap_two;

    // Synchronize data_en into clk_a domain register en_data_reg and latch data_in into data_reg on data_en
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            en_data_reg <= 1'b0;
            data_reg    <= 4'b0;
        end else begin
            en_data_reg <= data_en;
            if (data_en)
                data_reg <= data_in;
        end
    end

    // Two-stage synchronization of en_data_reg into clk_b domain, synchronous reset brstn
    always @(posedge clk_b) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // Dataout register update on clk_b domain with synchronous reset
    always @(posedge clk_b) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else begin
            // When synchronized enable is asserted, latch data_reg; else keep previous value
            if (en_clap_two)
                dataout <= data_reg;
        end
    end

endmodule