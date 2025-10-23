module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // sync reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain registers
    reg [3:0] data_reg;
    reg       en_data_reg;

    // clk_b domain registers for enable synchronization
    reg en_clap_one;
    reg en_clap_two;

    // Wire for synchronized enable in clk_b domain
    wire en_clap_two_wire = en_clap_two;

    // clk_a domain: Separate always blocks for clarity
    // Update en_data_reg every clock cycle with asynchronous reset
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) 
            en_data_reg <= 1'b0;
        else 
            en_data_reg <= data_en;
    end

    // Update data_reg only when data_en is high, asynchronous reset
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_reg <= 4'd0;
        else if (data_en)
            data_reg <= data_in;
        // else hold previous value to reduce toggling
    end

    // clk_b domain: Two-stage synchronizer for enable with synchronous reset
    always @(posedge clk_b) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // clk_b domain: Update output data with synchronous reset
    always @(posedge clk_b) begin
        if (!brstn)
            dataout <= 4'd0;
        else if (en_clap_two_wire)
            dataout <= data_reg;
        // else hold previous value
    end

endmodule