module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active-low reset clk_a domain (asynchronous)
    input  wire        brstn,      // active-low reset clk_b domain (asynchronous)
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Registers in clk_a domain
    reg [3:0] data_reg;
    reg       en_data_reg;

    // Registers in clk_b domain for enable control (2-stage synchronizer)
    reg en_clap_one, en_clap_two;

    // Internal signals to detect rising edge of data_en in clk_a domain
    reg data_en_d;

    // Detect stable data_en high to update data_reg and en_data_reg only on first assertion or continuous high
    // To reduce toggling, only update when data_en rises or remains high

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
            data_en_d   <= 1'b0;
        end else begin
            data_en_d <= data_en;
            if (data_en) begin
                // Update data_reg on rising edge or while data_en is high
                if (!data_en_d) begin
                    data_reg    <= data_in;
                    en_data_reg <= 1'b1;
                end else begin
                    // data_en stable high, keep en_data_reg asserted, but do not update data_reg to reduce toggling
                    en_data_reg <= 1'b1;
                end
            end else begin
                // data_en low: de-assert enable register
                en_data_reg <= 1'b0;
            end
        end
    end

    // clk_b domain: 2-stage synchronizer for en_data_reg to mitigate metastability
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // clk_b domain: update dataout only when synchronized enable is asserted, using explicit clock enable style
    // This avoids conditional assignment inside always block improving timing
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else if (en_clap_two) begin
            dataout <= data_reg;
        end
        // else retain previous dataout (no else clause needed due to reg nature)
    end

endmodule