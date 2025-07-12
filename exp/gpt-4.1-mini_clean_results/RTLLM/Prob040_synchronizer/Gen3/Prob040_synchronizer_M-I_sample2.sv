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

    // Registers in clk_b domain for enable control (2-stage synchronizer)
    reg en_clap_one;
    reg en_clap_two;

    // clk_a domain: capture data_in and data_en with async reset, update only when data_en is high
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
        end else if (data_en) begin
            data_reg    <= data_in;
            en_data_reg <= 1'b1;
        end else begin
            // Hold previous values to avoid toggling
            data_reg    <= data_reg;
            en_data_reg <= 1'b0;
        end
    end

    // clk_b domain: 2-stage synchronizer for en_data_reg and output logic with sync reset
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