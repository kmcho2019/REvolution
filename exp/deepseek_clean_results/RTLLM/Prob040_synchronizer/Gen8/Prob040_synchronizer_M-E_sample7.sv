module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // clk_a domain registers
    reg [3:0] data_reg_a;
    reg en_reg_a;
    reg data_valid_a;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a <= 4'b0;
            en_reg_a <= 1'b0;
            data_valid_a <= 1'b0;
        end else begin
            data_reg_a <= data_in;
            en_reg_a <= data_en;
            // Set valid when enable transitions high
            data_valid_a <= data_en && !en_reg_a;
        end
    end

    // clk_b domain synchronization
    reg [3:0] data_sync1, data_sync2;
    reg valid_sync1, valid_sync2;
    reg data_hold;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            data_sync1 <= 4'b0;
            data_sync2 <= 4'b0;
            valid_sync1 <= 1'b0;
            valid_sync2 <= 1'b0;
            dataout <= 4'b0;
            data_hold <= 4'b0;
        end else begin
            // First stage sync
            data_sync1 <= data_reg_a;
            valid_sync1 <= data_valid_a;
            
            // Second stage sync
            data_sync2 <= data_sync1;
            valid_sync2 <= valid_sync1;
            
            // Update hold register when new valid data arrives
            if (valid_sync2) begin
                data_hold <= data_sync2;
            end
            
            // Output updates only when we have stable data
            if (valid_sync2 || !valid_sync1) begin
                dataout <= data_hold;
            end
        end
    end

endmodule