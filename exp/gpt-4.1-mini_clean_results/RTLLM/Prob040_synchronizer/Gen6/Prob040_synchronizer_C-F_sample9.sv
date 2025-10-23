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

    // clk_a domain: capture data_in and data_en with asynchronous reset
    // data_reg updates only when data_en is high to reduce toggling
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
            if (data_en)
                data_reg <= data_in;
            // else keep data_reg unchanged to avoid unnecessary toggling
        end
    end

    // clk_b domain: 2-stage synchronizer for enable signal, synchronous reset
    always @(posedge clk_b) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // clk_b domain: output register update with synchronous reset,
    // update dataout only when enable is stable and asserted to reduce toggling
    always @(posedge clk_b) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_clap_two) begin
            dataout <= data_reg;
        end
        // else retain previous dataout value (no change)
    end

endmodule