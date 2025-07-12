module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,      // active-low reset for clk_a domain
    input  wire        brstn,      // active-low reset for clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Register data_in in clk_a domain only when data_en is high
    reg [3:0] data_reg;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_reg <= 4'd0;
        else if (data_en)
            data_reg <= data_in;
    end

    // Synchronize data_en from clk_a domain to clk_b domain using 2-flip-flops
    reg en_sync_ff1, en_sync_ff2;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_ff1 <= 1'b0;
            en_sync_ff2 <= 1'b0;
        end else begin
            en_sync_ff1 <= data_en;
            en_sync_ff2 <= en_sync_ff1;
        end
    end

    // Double-register data_reg in clk_b domain to safely cross clock domains
    reg [3:0] data_reg_b_ff1, data_reg_b_ff2;

    // Capture data_reg into clk_b domain data register at clk_b rising edge
    // The capture is enabled only when en_sync_ff2 is asserted to ensure stable transfer
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_reg_b_ff1 <= 4'd0;
            data_reg_b_ff2 <= 4'd0;
        end else begin
            if (en_sync_ff2) begin
                data_reg_b_ff1 <= data_reg;
            end
            data_reg_b_ff2 <= data_reg_b_ff1;
        end
    end

    // Output register logic: update output only when synchronized enable is asserted
    // Otherwise retain previous output to avoid glitches
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else if (en_sync_ff2) begin
            dataout <= data_reg_b_ff2;
        end
        // else retain previous dataout
    end

endmodule