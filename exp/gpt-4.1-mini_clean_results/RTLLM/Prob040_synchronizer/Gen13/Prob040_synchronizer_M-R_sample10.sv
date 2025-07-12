module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,
    input  wire        brstn,
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // Register data_in in clk_a domain
    reg [3:0] data_reg;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_reg <= 4'b0;
        else
            data_reg <= data_in;
    end

    // Create a pulse for data_en rising edge in clk_a domain
    reg data_en_d;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_en_d <= 1'b0;
        else
            data_en_d <= data_en;
    end

    wire data_en_pulse = data_en & ~data_en_d;

    // Synchronize pulse to clk_b domain
    reg sync_en_0, sync_en_1;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            sync_en_0 <= 1'b0;
            sync_en_1 <= 1'b0;
        end else begin
            sync_en_0 <= data_en_pulse;
            sync_en_1 <= sync_en_0;
        end
    end

    // Latch data_reg into clk_b domain register on synchronized pulse
    reg [3:0] latched_data;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            latched_data <= 4'b0;
        else if (sync_en_1)
            latched_data <= data_reg;
    end

    // Output dataout updated only when latched_data updated
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            dataout <= 4'b0;
        else if (sync_en_1)
            dataout <= latched_data;
        else
            dataout <= dataout;
    end

endmodule