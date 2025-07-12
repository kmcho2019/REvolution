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
    reg pulse_a;
    reg [3:0] data_hold;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_en_prev <= 1'b0;
            pulse_a <= 1'b0;
            data_hold <= 4'b0;
        end else begin
            data_en_prev <= data_en;
            // Detect rising edge of data_en
            pulse_a <= data_en && !data_en_prev;
            // Capture data when enable first goes high
            if (pulse_a) begin
                data_hold <= data_in;
            end
        end
    end

    // Clock B domain - Toggle synchronizer
    reg toggle_a;
    reg toggle_b1, toggle_b2;
    reg toggle_b_prev;
    reg pulse_b;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            toggle_a <= 1'b0;
        end else if (pulse_a) begin
            toggle_a <= ~toggle_a;
        end
    end

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            toggle_b1 <= 1'b0;
            toggle_b2 <= 1'b0;
            toggle_b_prev <= 1'b0;
            pulse_b <= 1'b0;
        end else begin
            toggle_b1 <= toggle_a;
            toggle_b2 <= toggle_b1;
            toggle_b_prev <= toggle_b2;
            // Detect toggle change
            pulse_b <= (toggle_b2 != toggle_b_prev);
        end
    end

    // Data transfer and output register
    reg [3:0] data_sync;
    reg sync_complete;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
            data_sync <= 4'b0;
            sync_complete <= 1'b0;
        end else if (pulse_b) begin
            data_sync <= data_hold;
            dataout <= data_hold;
            sync_complete <= 1'b1;
        end else begin
            sync_complete <= 1'b0;
        end
    end

    // Optional: Feedback path to verify data stability
    reg [1:0] stability_counter;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            stability_counter <= 2'b0;
        end else if (data_en) begin
            stability_counter <= stability_counter + 1;
        end else begin
            stability_counter <= 2'b0;
        end
    end

endmodule