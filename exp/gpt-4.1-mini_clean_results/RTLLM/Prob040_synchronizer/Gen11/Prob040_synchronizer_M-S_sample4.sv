module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active-low reset clk_a domain
    input  wire        brstn,      // active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Register data_reg in clk_a domain captures data_in when data_en is high
    reg [3:0] data_reg;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_reg <= 4'd0;
        else if (data_en)
            data_reg <= data_in;
    end

    // Two-stage synchronizer for data_en from clk_a domain to clk_b domain
    reg en_sync_1, en_sync_2;
    // Delay en_sync_2 by one more cycle
    reg en_sync_3;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_1 <= 1'b0;
            en_sync_2 <= 1'b0;
            en_sync_3 <= 1'b0;
            dataout   <= 4'd0;
        end else begin
            en_sync_1 <= data_en;
            en_sync_2 <= en_sync_1;
            en_sync_3 <= en_sync_2;

            if (en_sync_3)
                dataout <= data_reg;
        end
    end

endmodule