module en_sync(
    input        clk_b,
    input        brstn,
    input        en_in,
    output reg   en_sync_out
);
    reg en_ff1;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_ff1      <= 1'b0;
            en_sync_out <= 1'b0;
        end else begin
            en_ff1      <= en_in;
            en_sync_out <= en_ff1;
        end
    end
endmodule


module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset active low clk_a domain
    input  wire        brstn,      // async reset active low clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;    // latch input data when data_en is high
    reg       en_data_reg; // latched data_en for synchronization

    // Register in clk_b domain to hold synchronized data from clk_a domain
    reg [3:0] data_sync;

    // Wire from en_sync module: synchronized enable signal delayed two clk_b cycles
    wire en_clap_two;

    // clk_a domain: latch data_in and data_en with asynchronous reset
    // data_reg updated only if data_en is high to minimize toggling
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
            if (data_en)
                data_reg <= data_in;
            // else hold previous data_reg value
        end
    end

    // Instantiate two-stage enable synchronizer crossing clk_a to clk_b domain
    en_sync en_sync_inst (
        .clk_b(clk_b),
        .brstn(brstn),
        .en_in(en_data_reg),
        .en_sync_out(en_clap_two)
    );

    // clk_b domain: update data_sync only when synchronized enable is high to reduce toggling
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_sync <= 4'b0;
        end else if (en_clap_two) begin
            data_sync <= data_reg;
        end
        // else hold previous data_sync value
    end

    // clk_b domain: output register updates every cycle using mux between data_sync and previous dataout
    // Implements MUX behavior gated by synchronized enable signal
    wire [3:0] mux_dataout = en_clap_two ? data_sync : dataout;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else begin
            dataout <= mux_dataout;
        end
    end

endmodule