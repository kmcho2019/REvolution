module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,     // active-low reset clk_a domain
    input  wire        brstn,     // active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain registers: sample data_in and data_en asynchronously
    reg [3:0] data_reg;
    reg       en_data_reg;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg    <= data_in;
            en_data_reg <= data_en;
        end
    end

    // clk_b domain: use a 3-bit shift register for en_data_reg synchronization and filtering
    reg [2:0] en_shift;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_shift <= 3'b000;
            dataout  <= 4'd0;
        end else begin
            // shift in the sampled enable from clk_a domain
            en_shift <= {en_shift[1:0], en_data_reg};

            // update dataout only when en_shift shows enable stable for 3 clk_b cycles (equivalent to 2 delay stages)
            if (&en_shift) begin
                dataout <= data_reg;
            end
            // else retain dataout value (no explicit else needed since registers hold value)
        end
    end

endmodule