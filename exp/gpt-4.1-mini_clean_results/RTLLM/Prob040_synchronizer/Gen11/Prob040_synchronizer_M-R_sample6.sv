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

    // clk_a domain: data_reg samples data_in when data_en is high, with async reset
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_reg <= 4'b0;
        else if (data_en)
            data_reg <= data_in;
        else
            data_reg <= data_reg; // Hold previous value explicitly
    end

    // clk_a domain: en_data_reg register, async reset
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            en_data_reg <= 1'b0;
        else
            en_data_reg <= data_en;
    end

    // clk_b domain: two-stage synchronizer for enable signal, synchronous reset
    always @(posedge clk_b) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // clk_b domain: dataout updated combinationally when en_clap_two asserted, synchronous reset
    always @(posedge clk_b) begin
        if (!brstn)
            dataout <= 4'b0;
        else if (en_clap_two)
            dataout <= data_reg;
        else
            dataout <= dataout; // Hold previous value explicitly
    end

endmodule