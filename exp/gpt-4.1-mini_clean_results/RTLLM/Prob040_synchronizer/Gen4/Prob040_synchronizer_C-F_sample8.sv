module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,     // active-low reset clk_a domain
    input  wire        brstn,     // active-low reset clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain registers
    reg [3:0] data_reg;        // stores input data when data_en is high
    reg       en_data_reg;     // registered enable in clk_a domain

    // clk_b domain enable synchronizer
    reg en_sync_0, en_sync_1;

    // For rising edge detection of synchronized enable in clk_b domain
    reg en_sync_1_d;

    // clk_b domain data hold register
    reg [3:0] data_hold;

    // clk_a domain: capture data_in and data_en, gated by data_en to reduce toggling
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            en_data_reg <= data_en;
            if (data_en)
                data_reg <= data_in;
        end
    end

    // clk_b domain: two-stage synchronizer for enable
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_0 <= 1'b0;
            en_sync_1 <= 1'b0;
        end else begin
            en_sync_0 <= en_data_reg;
            en_sync_1 <= en_sync_0;
        end
    end

    // clk_b domain: register previous en_sync_1 for rising edge detection
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_1_d <= 1'b0;
        end else begin
            en_sync_1_d <= en_sync_1;
        end
    end

    // Rising edge pulse of synchronized enable in clk_b domain
    wire en_pulse = en_sync_1 & ~en_sync_1_d;

    // clk_b domain: latch data_reg into data_hold on en_pulse
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_hold <= 4'd0;
        end else if (en_pulse) begin
            data_hold <= data_reg;
        end
    end

    // clk_b domain: output register updates on every clock, holds last value when no pulse
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else begin
            dataout <= data_hold;
        end
    end

endmodule