module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // clk_a domain signals
    reg [3:0] data_latched;
    reg data_stable;
    reg [3:0] prev_data;
    reg [1:0] en_counter;

    // Stability checking logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_latched <= 4'b0;
            data_stable <= 1'b0;
            prev_data <= 4'b0;
            en_counter <= 2'b0;
        end else begin
            prev_data <= data_in;
            
            if (data_en) begin
                // Check if data changed during enable
                if (prev_data != data_in) begin
                    data_stable <= 1'b0;
                    en_counter <= 2'b0;
                end else begin
                    // Count stable cycles
                    if (en_counter < 2'b11) 
                        en_counter <= en_counter + 1;
                    
                    // Mark stable after 2 cycles
                    data_stable <= (en_counter >= 2'b10);
                end
                
                // Latch data when stable
                if (data_stable)
                    data_latched <= data_in;
            end else begin
                data_stable <= 1'b0;
                en_counter <= 2'b0;
            end
        end
    end

    // clk_b domain synchronization
    reg [1:0] stable_sync;
    reg [3:0] data_sync [1:0];
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            stable_sync <= 2'b0;
            data_sync[0] <= 4'b0;
            data_sync[1] <= 4'b0;
        end else begin
            // Two-stage sync for stability signal
            stable_sync <= {stable_sync[0], data_stable};
            
            // Two-stage sync for data
            data_sync[0] <= data_latched;
            data_sync[1] <= data_sync[0];
        end
    end

    // Output assignment with valid qualifier
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (stable_sync[1]) begin
            dataout <= data_sync[1];
        end
    end

endmodule