module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active-low reset clk_a domain
    input  wire        brstn,      // active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain registers
    reg [3:0] data_reg;
    reg       en_data_reg;

    // clk_b domain registers for enable synchronizer
    reg en_clap_one, en_clap_two;

    // clk_a domain: data_reg update
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_reg <= 4'd0;
        else
            data_reg <= data_in;
    end

    // clk_a domain: en_data_reg update
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            en_data_reg <= 1'b0;
        else
            en_data_reg <= data_en;
    end

    // clk_b domain: 2-stage synchronizer for en_data_reg
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // clk_b domain: dataout update controlled by en_clap_two
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            dataout <= 4'd0;
        else if (en_clap_two)
            dataout <= data_reg;
        else
            dataout <= dataout; // hold previous value explicitly
    end

endmodule