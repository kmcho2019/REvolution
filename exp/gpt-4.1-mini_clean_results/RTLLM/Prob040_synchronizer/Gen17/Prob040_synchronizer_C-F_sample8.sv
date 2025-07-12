module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // async reset, active low, clk_a domain
    input  wire        brstn,      // async reset, active low, clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;
    reg       en_reg;

    // Three-stage synchronizer for enable in clk_b domain
    reg en_sync1, en_sync2, en_sync3;

    // clk_a domain: async reset; update registers on posedge clk_a
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

    // clk_b domain: async reset; synchronize enable across clk domains with three flip-flops
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
            en_sync3 <= 1'b0;
        end else begin
            en_sync1 <= en_reg;
            en_sync2 <= en_sync1;
            en_sync3 <= en_sync2;
        end
    end

    // clk_b domain: async reset; update dataout when delayed enable is high
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else if (en_sync3) begin
            dataout <= data_reg;
        end
        // else hold previous value implicitly
    end

endmodule