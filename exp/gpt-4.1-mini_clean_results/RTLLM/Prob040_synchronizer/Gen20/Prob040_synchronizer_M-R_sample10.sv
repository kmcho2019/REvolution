module enable_sync (
    input  wire clk_b,
    input  wire brstn,
    input  wire async_en,
    output wire sync_en
);
    // Two-stage synchronizer for single bit enable signal crossing clk domains
    reg [1:0] sync_stages;

    always @(posedge clk_b) begin
        if (!brstn)
            sync_stages <= 2'b00;
        else
            sync_stages <= {sync_stages[0], async_en};
    end

    assign sync_en = sync_stages[1];

endmodule

module synchronizer (
    input  wire        clk_a,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        clk_b,
    input  wire        brstn,      // sync reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain for data and enable
    reg [3:0] data_reg;
    reg       en_data_reg;

    // Synchronizer output for enable in clk_b domain
    wire en_clap_two;

    // clk_a domain: async reset and data/en update
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
            if (data_en)
                data_reg <= data_in;
        end
    end

    // Instantiate enable synchronizer crossing from clk_a domain to clk_b domain
    // async_en = en_data_reg (in clk_a domain), sync_en = en_clap_two (in clk_b domain)
    enable_sync u_enable_sync (
        .clk_b(clk_b),
        .brstn(brstn),
        .async_en(en_data_reg),
        .sync_en(en_clap_two)
    );

    // clk_b domain: synchronous reset and dataout latch
    always @(posedge clk_b) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_clap_two) begin
            dataout <= data_reg;
        end
        // else dataout holds its value
    end

endmodule