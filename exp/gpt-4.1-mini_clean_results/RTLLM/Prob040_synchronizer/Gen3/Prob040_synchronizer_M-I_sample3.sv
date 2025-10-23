module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,     // active-low async reset clk_a domain
    input  wire        brstn,     // active-low synchronous reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;
    reg       en_data_reg;

    // Registers in clk_b domain for 2-stage enable synchronizer
    reg [1:0] en_sync;

    // clk_a domain: capture data_in and data_en with async reset and explicit enable
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
            if (data_en) begin
                data_reg <= data_in;
            end
            // else data_reg holds previous value (no assignment)
        end
    end

    // clk_b domain: 2-stage synchronizer for en_data_reg and output data with synchronous reset
    always @(posedge clk_b) begin
        if (!brstn) begin
            en_sync  <= 2'b00;
            dataout  <= 4'b0;
        end else begin
            en_sync <= {en_sync[0], en_data_reg};
            if (en_sync[1])
                dataout <= data_reg;
            // else dataout holds its previous value implicitly
        end
    end

endmodule