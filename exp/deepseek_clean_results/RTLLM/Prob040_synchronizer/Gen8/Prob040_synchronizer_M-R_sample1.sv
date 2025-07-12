module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A signals
    reg [3:0] data_reg_a;
    reg en_reg_a;

    // Clock domain B signals
    reg [3:0] data_reg_b;
    reg en_sync1, en_sync2;
    wire en_sync_pulse = en_sync2 & ~en_sync1;  // Detect rising edge

    // Clock domain A logic - capture data when enabled
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a <= 4'b0;
            en_reg_a <= 1'b0;
        end else begin
            if (data_en) begin
                data_reg_a <= data_in;
                en_reg_a <= 1'b1;
            end else begin
                en_reg_a <= 1'b0;
            end
        end
    end

    // Clock domain B logic - synchronize enable and capture data
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
            data_reg_b <= 4'b0;
            dataout <= 4'b0;
        end else begin
            // 2-stage synchronizer for enable signal
            en_sync1 <= en_reg_a;
            en_sync2 <= en_sync1;

            // Capture data on rising edge of synchronized enable
            if (en_sync_pulse) begin
                data_reg_b <= data_reg_a;
            end

            // Output is always registered version of data_reg_b
            dataout <= data_reg_b;
        end
    end

endmodule