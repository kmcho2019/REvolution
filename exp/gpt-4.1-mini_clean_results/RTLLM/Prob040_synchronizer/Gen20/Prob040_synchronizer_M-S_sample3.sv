module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // sync reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Register to hold data in clk_a domain
    reg [3:0] data_reg;

    // Single-stage synchronizer for data_en in clk_b domain
    reg en_sync;

    // clk_a domain: async reset; update data_reg only when data_en is high
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'd0;
        end else if (data_en) begin
            data_reg <= data_in;
        end
    end

    // clk_b domain: synchronous reset; single flip-flop synchronizer for data_en; output update
    always @(posedge clk_b) begin
        if (!brstn) begin
            en_sync <= 1'b0;
            dataout <= 4'd0;
        end else begin
            en_sync <= data_en;  // sample async data_en directly, safe due to long high period
            if (en_sync)
                dataout <= data_reg;
            // else retain dataout
        end
    end

endmodule