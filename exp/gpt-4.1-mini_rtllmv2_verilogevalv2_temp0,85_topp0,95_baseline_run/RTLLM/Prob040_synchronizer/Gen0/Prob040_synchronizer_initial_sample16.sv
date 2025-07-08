module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,
    input  wire        brstn,
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Register to store input data sampled on clk_a
    reg [3:0] data_reg;
    // Register to store input enable sampled on clk_a
    reg       en_data_reg;

    // Two flip-flops to delay enable signal on clk_b domain
    reg en_clap_one;
    reg en_clap_two;

    // Sample data_in and data_en on clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg     <= 4'b0;
            en_data_reg  <= 1'b0;
        end else begin
            data_reg     <= data_in;
            en_data_reg  <= data_en;
        end
    end

    // Synchronize enable signal on clk_b domain through two flip-flops
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // Assign output dataout on clk_b domain based on delayed enable signal
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_clap_two) begin
            dataout <= data_reg;
        end else begin
            dataout <= dataout;
        end
    end

endmodule