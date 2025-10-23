module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock A domain - Edge detection and data capture
    reg data_en_prev;
    reg [3:0] data_reg;
    wire data_en_posedge = data_en & ~data_en_prev;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_en_prev <= 1'b0;
            data_reg <= 4'b0;
        end else begin
            data_en_prev <= data_en;
            if (data_en_posedge) begin
                data_reg <= data_in;
            end
        end
    end

    // Clock B domain - Pulse synchronization and window generation
    reg [1:0] sync_chain;
    reg [1:0] window_counter;
    reg window_active;
    reg data_valid;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            sync_chain <= 2'b00;
            window_counter <= 2'b00;
            window_active <= 1'b0;
            data_valid <= 1'b0;
        end else begin
            // Synchronize the edge pulse
            sync_chain <= {sync_chain[0], data_en_posedge};
            
            // Window control logic
            if (sync_chain[1]) begin
                window_active <= 1'b1;
                window_counter <= 2'b00;
            end else if (window_active) begin
                window_counter <= window_counter + 1;
                if (window_counter == 2'b10) begin
                    window_active <= 1'b0;
                end
            end
            
            // Data valid flag
            data_valid <= window_active && (window_counter == 2'b01);
        end
    end

    // Output register with stability window
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (data_valid) begin
            dataout <= data_reg;
        end
    end

endmodule