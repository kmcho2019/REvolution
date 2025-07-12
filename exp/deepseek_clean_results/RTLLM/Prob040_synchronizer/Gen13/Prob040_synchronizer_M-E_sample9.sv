module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock A domain logic
    reg [3:0] data_reg;
    reg en_pulse;
    reg en_hold;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_pulse <= 1'b0;
            en_hold <= 1'b0;
        end else begin
            // Capture data when enabled
            if (data_en) begin
                data_reg <= data_in;
                en_pulse <= 1'b1;
            end
            
            // Hold the pulse until synchronized
            if (en_pulse && !en_hold) begin
                en_hold <= 1'b1;
            end else if (!en_pulse && en_hold) begin
                en_hold <= 1'b0;
            end
        end
    end

    // Clock B domain synchronization
    reg [1:0] sync_chain;
    reg [3:0] data_hold;
    reg data_valid;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            sync_chain <= 2'b00;
            data_hold <= 4'b0;
            data_valid <= 1'b0;
        end else begin
            // Synchronize enable pulse
            sync_chain <= {sync_chain[0], en_hold};
            
            // Detect rising edge of synchronized enable
            if (sync_chain == 2'b01) begin
                data_hold <= data_reg;
                data_valid <= 1'b1;
            end else if (sync_chain == 2'b10) begin
                data_valid <= 1'b0;
            end
            
            // Output update only when valid
            if (data_valid) begin
                dataout <= data_hold;
            end
        end
    end

endmodule