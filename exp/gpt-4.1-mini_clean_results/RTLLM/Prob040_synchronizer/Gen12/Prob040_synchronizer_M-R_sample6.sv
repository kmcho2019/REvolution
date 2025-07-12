module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,
    input  wire        brstn,
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Data register in clk_a domain
    reg [3:0] data_reg;
    reg       en_data_reg;

    // Synchronizer flip-flops in clk_b domain
    reg en_clap_one, en_clap_two;

    // Update data_reg and en_data_reg on clk_a
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg    <= data_in;
            en_data_reg <= data_en;
        end
    end

    // Two-stage synchronizer of enable in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // MUX output data based on synchronized enable
    wire [3:0] data_mux = en_clap_two ? data_reg : dataout;

    // Update output dataout register on clk_b
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else begin
            dataout <= data_mux;
        end
    end

endmodule