module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active-low reset clk_a domain
    input  wire        brstn,      // active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;
    reg       en_data_reg;

    // Registers in clk_b domain for enable control (2-stage synchronizer)
    reg en_clap_one, en_clap_two_reg;
    wire en_clap_two;

    // clk_a domain: update data_reg and en_data_reg synchronously with async reset
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg    <= data_in;
            en_data_reg <= data_en;
        end
    end

    // clk_b domain: 2-stage synchronizer for en_data_reg
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one     <= 1'b0;
            en_clap_two_reg <= 1'b0;
        end else begin
            en_clap_one     <= en_data_reg;
            en_clap_two_reg <= en_clap_one;
        end
    end

    // Use continuous assignment for delayed enable
    assign en_clap_two = en_clap_two_reg;

    // clk_b domain: update dataout when delayed enable is high, else hold previous value
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else if (en_clap_two) begin
            dataout <= data_reg;
        end else begin
            dataout <= dataout;
        end
    end

endmodule