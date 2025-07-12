module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,     // active-low reset clk_a domain
    input  wire        brstn,     // active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;
    reg       en_data_reg;

    // Registers in clk_b domain for enable synchronization
    reg en_clap_one, en_clap_two;

    // clk_a domain: update data_reg and en_data_reg only when data_en is high
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            // Update data_reg only if data_en is high (data stable during data_en)
            if (data_en)
                data_reg <= data_in;
            en_data_reg <= data_en; // en_data_reg tracks data_en continuously for synchronization
        end
    end

    // clk_b domain: 2-stage synchronizer for enable and dataout update with synchronous reset
    always @(posedge clk_b) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
            dataout     <= 4'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
            if (en_clap_two)
                dataout <= data_reg;
        end
    end

endmodule