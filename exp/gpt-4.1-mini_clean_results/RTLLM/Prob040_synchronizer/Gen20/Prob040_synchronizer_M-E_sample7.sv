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

    // clk_b domain enable synchronizer registers
    reg en_sync1, en_sync2;
    reg data_valid_reg;

    // Previous value of en_sync2 for edge detection
    reg en_sync2_d;

    // Register data_in and data_en in clk_a domain when enabled
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg     <= 4'd0;
            en_data_reg  <= 1'b0;
        end else begin
            if (data_en) begin
                data_reg    <= data_in;
                en_data_reg <= 1'b1;
            end else begin
                en_data_reg <= 1'b0;
            end
        end
    end

    // Synchronize en_data_reg into clk_b domain with two flip-flops
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
        end else begin
            en_sync1 <= en_data_reg;
            en_sync2 <= en_sync1;
        end
    end

    // Edge detection of en_sync2 to generate data_valid_reg pulse
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync2_d   <= 1'b0;
            data_valid_reg <= 1'b0;
        end else begin
            en_sync2_d <= en_sync2;
            data_valid_reg <= en_sync2 & ~en_sync2_d;  // detect rising edge
        end
    end

    // Update output data when a valid new data pulse is detected
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else if (data_valid_reg) begin
            dataout <= data_reg;
        end
        // else keep previous value
    end

endmodule