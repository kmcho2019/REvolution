module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,
    input  wire        brstn,
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;       // Holds latched data when data_en asserted
    reg       en_reg;         // Holds data_en sampled on clk_a

    // Two-stage synchronizer flip-flops in clk_b domain
    reg en_sync_1, en_sync_2;

    // Latch data_in only when data_en is high, else hold previous data_reg
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'd0;
            en_reg   <= 1'b0;
        end else begin
            if (data_en)
                data_reg <= data_in;
            en_reg <= data_en;
        end
    end

    // Two-stage synchronizer for enable from clk_a to clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_1 <= 1'b0;
            en_sync_2 <= 1'b0;
        end else begin
            en_sync_1 <= en_reg;
            en_sync_2 <= en_sync_1;
        end
    end

    // Output register updated only when synchronized enable is high
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else begin
            if (en_sync_2)
                dataout <= data_reg;
            else
                dataout <= dataout; // Hold previous value
        end
    end

endmodule