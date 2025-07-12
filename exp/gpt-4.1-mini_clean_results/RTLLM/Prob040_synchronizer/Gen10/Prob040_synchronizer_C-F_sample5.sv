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

    // Registers in clk_b domain for enable synchronization (2-stage)
    reg en_clap_one, en_clap_two;

    // clk_a domain: async reset, update data_reg and en_data_reg only when data_en is high to reduce toggling
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            if (data_en) begin
                data_reg    <= data_in;
                en_data_reg <= 1'b1;
            end else begin
                en_data_reg <= 1'b0;
                // hold data_reg when data_en is low (no update)
            end
        end
    end

    // clk_b domain: synchronous reset, 2-stage enable synchronization and conditional dataout update
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
            dataout     <= 4'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
            if (en_clap_two)
                dataout <= data_reg;
            // else dataout retains its previous value
        end
    end

endmodule