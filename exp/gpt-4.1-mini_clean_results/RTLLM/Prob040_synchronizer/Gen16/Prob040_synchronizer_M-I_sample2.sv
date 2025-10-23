module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active-low reset clk_a domain
    input  wire        brstn,      // active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Data register updated on clk_a domain, only when data_en is high
    reg [3:0] data_reg;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_reg <= 4'd0;
        else if (data_en)
            data_reg <= data_in;
    end

    // Enable registers synchronized and delayed by two flip-flops in clk_b domain
    reg en_clap_one, en_clap_two;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= data_en;
            en_clap_two <= en_clap_one;
        end
    end

    // Output data register updated on clk_b domain when delayed enable is high
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            dataout <= 4'd0;
        else if (en_clap_two)
            dataout <= data_reg;
        // else retain previous value
    end

endmodule