module synchronizer (
    input  wire        clk_a,
    input  wire        clk_b,
    input  wire        arstn,       // async reset active low clk_a domain
    input  wire        brstn,       // sync reset active low clk_b domain
    input  wire [3:0]  data_in,
    input  wire        data_en,
    output reg  [3:0]  dataout
);

    // clk_a domain registers
    reg [3:0] data_reg;          // latch data_in when data_en is high
    reg       data_valid;        // pulse to indicate new data latched

    // Synchronizer of data_valid signal into clk_b domain (2-stage synchronizer)
    reg sync_data_valid_ff1, sync_data_valid_ff2;

    // Detect rising edge of synchronized data_valid in clk_b domain
    reg sync_data_valid_ff2_d;

    // Data register in clk_b domain to hold synchronized data
    reg [3:0] data_sync;

    // clk_a domain: async reset, latch data and pulse data_valid on data_en high
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg   <= 4'd0;
            data_valid <= 1'b0;
        end else begin
            if (data_en) begin
                data_reg   <= data_in;
                data_valid <= 1'b1;    // pulse to indicate new data
            end else begin
                data_valid <= 1'b0;
            end
        end
    end

    // clk_b domain: sync data_valid through 2-flip-flop synchronizer
    always @(posedge clk_b) begin
        if (!brstn) begin
            sync_data_valid_ff1 <= 1'b0;
            sync_data_valid_ff2 <= 1'b0;
            sync_data_valid_ff2_d <= 1'b0;
            data_sync <= 4'd0;
            dataout <= 4'd0;
        end else begin
            // Synchronize pulse signal safely
            sync_data_valid_ff1 <= data_valid;
            sync_data_valid_ff2 <= sync_data_valid_ff1;

            // Detect rising edge of synchronized data_valid pulse
            sync_data_valid_ff2_d <= sync_data_valid_ff2;

            if (sync_data_valid_ff2 && !sync_data_valid_ff2_d) begin
                // Rising edge detected, latch new data
                data_sync <= data_reg;
                dataout <= data_reg;
            end
            // else hold previous data_sync and dataout stable
        end
    end

endmodule