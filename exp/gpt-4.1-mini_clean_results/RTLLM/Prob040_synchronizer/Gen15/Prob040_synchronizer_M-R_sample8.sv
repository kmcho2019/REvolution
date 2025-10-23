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

    // clk_b domain registers for enable synchronization as shift register [1:0]
    reg [1:0] en_sync;

    // Synchronize enable signal from clk_a domain to clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            en_sync <= 2'b00;
        else
            en_sync <= {en_sync[0], en_data_reg};
    end

    // clk_a domain: asynchronous reset, sample enable unconditionally, update data only when enable is high
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            en_data_reg <= 1'b0;
            data_reg    <= 4'd0;
        end else begin
            en_data_reg <= data_en;
            if (data_en)
                data_reg <= data_in;
            // else retain data_reg
        end
    end

    // clk_b domain: update dataout on positive edge, reset asynchronously,
    // update output only when synchronized enable signal (en_sync[1]) is high
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else if (en_sync[1]) begin
            dataout <= data_reg;
        end
        // else hold previous dataout
    end

endmodule