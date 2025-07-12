module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Register to store input data_in in clk_a domain
    reg [3:0] data_reg;
    // Register to store input enable in clk_a domain
    reg en_data_reg;

    // Registers for enable signal synchronization and delay in clk_b domain
    reg en_clap_one;
    reg en_clap_two;

    // clk_a domain process: register data_in and data_en with asynchronous active low reset
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg <= data_in;
            en_data_reg <= data_en;
        end
    end

    // clk_b domain process: double-register en_data_reg and update output dataout with enable
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
            dataout <= 4'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
            if (en_clap_two)
                dataout <= data_reg;
            else
                dataout <= dataout;
        end
    end

endmodule