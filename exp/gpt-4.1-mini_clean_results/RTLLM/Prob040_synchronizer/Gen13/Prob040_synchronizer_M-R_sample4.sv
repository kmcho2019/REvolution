module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // async reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain registers
    reg [3:0] data_reg;
    reg       en_data_reg;

    // Update data_reg and en_data_reg synchronously with clk_a and async reset arstn
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
            data_reg    <= (data_en) ? data_in : data_reg;
        end
    end

    // clk_b domain: two-stage synchronizer for en_data_reg
    reg en_sync_ff1, en_sync_ff2;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_ff1 <= 1'b0;
            en_sync_ff2 <= 1'b0;
        end else begin
            en_sync_ff1 <= en_data_reg;
            en_sync_ff2 <= en_sync_ff1;
        end
    end

    // Combine two-stage synchronizer outputs using assign
    wire en_clap_two;
    assign en_clap_two = en_sync_ff2;

    // clk_b domain: mux-based output update on rising clk_b edge or async reset
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else begin
            dataout <= (en_clap_two) ? data_reg : dataout;
        end
    end

endmodule