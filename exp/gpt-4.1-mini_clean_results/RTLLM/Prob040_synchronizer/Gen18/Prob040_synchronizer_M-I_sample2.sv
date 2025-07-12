module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // sync reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;      // stores data_in when data_en is high
    reg       en_data_reg;   // captures data_en every clk_a cycle

    // Registers in clk_b domain for enable synchronization (2-stage)
    reg en_clap_one, en_clap_two;

    // clk_a domain: asynchronous reset; capture data_en every cycle;
    // update data_reg only when data_en is high to reduce toggling
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
            if (data_en)
                data_reg <= data_in;
            // else hold previous data_reg to reduce unnecessary toggling
        end
    end

    // clk_b domain: synchronous reset; two-stage synchronizer for enable;
    // update dataout only when synchronized enable is high
    always @(posedge clk_b) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
            dataout     <= 4'd0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;

            if (en_clap_two) begin
                dataout <= data_reg;
            end
            // else hold previous dataout to avoid unnecessary toggling
        end
    end

endmodule