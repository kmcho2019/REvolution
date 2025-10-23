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
    reg en_pulse_a;
    reg [1:0] en_sync_a;

    // clk_b domain registers
    reg [3:0] data_reg_b;
    reg [1:0] en_sync_b;
    reg [2:0] en_stretch_b;
    reg [3:0] data_capture_b;
    reg [1:0] meta_filter [3:0];

    // clk_a domain logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a <= 4'b0;
            en_pulse_a <= 1'b0;
            en_sync_a <= 2'b00;
        end else begin
            // Capture data when enabled
            if (data_en) begin
                data_reg_a <= data_in;
            end
            
            // Generate single-cycle pulse at enable rising edge
            en_sync_a <= {en_sync_a[0], data_en};
            en_pulse_a <= en_sync_a[0] & ~en_sync_a[1];
        end
    end

    // clk_b domain - enable synchronization
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_b <= 2'b00;
            en_stretch_b <= 3'b000;
            data_reg_b <= 4'b0;
            data_capture_b <= 4'b0;
            for (int i = 0; i < 4; i++) begin
                meta_filter[i] <= 2'b00;
            end
        end else begin
            // Two-stage sync for enable pulse
            en_sync_b <= {en_sync_b[0], en_pulse_a};
            
            // Stretch enable for 3 cycles (known minimum)
            if (en_sync_b[1]) begin
                en_stretch_b <= 3'b111;
            end else if (|en_stretch_b) begin
                en_stretch_b <= {1'b0, en_stretch_b[2:1]};
            end
            
            // Capture data during stable window
            if (|en_stretch_b) begin
                data_reg_b <= data_reg_a;
            end
            
            // Metastability filter - require 3 consistent samples
            for (int i = 0; i < 4; i++) begin
                meta_filter[i] <= {meta_filter[i][0], data_reg_b[i]};
                if (meta_filter[i] == 2'b11) begin
                    data_capture_b[i] <= 1'b1;
                end else if (meta_filter[i] == 2'b00) begin
                    data_capture_b[i] <= 1'b0;
                end
            end
            
            // Update output only after full window
            if (en_stretch_b == 3'b001) begin  // End of window
                dataout <= data_capture_b;
            end
        end
    end

endmodule