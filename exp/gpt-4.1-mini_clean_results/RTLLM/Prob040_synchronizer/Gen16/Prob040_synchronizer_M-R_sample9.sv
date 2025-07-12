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
    reg       en_data_reg_prev;

    // clk_b domain registers for enable synchronization
    reg en_clap_one, en_clap_two;

    // clk_a domain: asynchronous reset, update data_reg when data_en is asserted,
    // update en_data_reg only when data_en changes to reduce toggling
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg        <= 4'd0;
            en_data_reg     <= 1'b0;
            en_data_reg_prev<= 1'b0;
        end else begin
            if (data_en)
                data_reg <= data_in;
            en_data_reg_prev <= en_data_reg;
            if (data_en != en_data_reg_prev)
                en_data_reg <= data_en;
        end
    end

    // clk_b domain: synchronous reset (with brstn used as sync reset for simplicity),
    // two-stage synchronizer for en_data_reg and dataout update combined into one always block
    always @(posedge clk_b) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
            dataout     <= 4'd0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;

            if (en_clap_two)
                dataout <= data_reg;
            // else dataout retains previous value
        end
    end

endmodule