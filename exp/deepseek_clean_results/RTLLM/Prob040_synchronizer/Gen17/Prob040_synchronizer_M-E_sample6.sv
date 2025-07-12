module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A registers
    reg [3:0] data_reg_a;
    reg en_reg_a;
    
    // Clock domain B synchronization registers
    reg [2:0] en_sync_b;  // 3-stage synchronizer
    reg [3:0] data_reg_b;
    reg en_stretched;
    reg [1:0] stretch_counter;
    
    // Reset synchronization
    reg arstn_sync_b;
    reg brstn_sync_a;
    
    // Synchronize resets between domains
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            arstn_sync_b <= 1'b0;
        end else begin
            arstn_sync_b <= arstn;
        end
    end
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            brstn_sync_a <= 1'b0;
        end else begin
            brstn_sync_a <= brstn;
        end
    end
    
    // Clock domain A processing
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a <= 4'b0;
            en_reg_a <= 1'b0;
        end else begin
            data_reg_a <= data_in;
            en_reg_a <= data_en;
        end
    end
    
    // Clock domain B synchronization
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_b <= 3'b0;
            data_reg_b <= 4'b0;
            en_stretched <= 1'b0;
            stretch_counter <= 2'b0;
            dataout <= 4'b0;
        end else begin
            // 3-stage enable synchronization
            en_sync_b <= {en_sync_b[1:0], en_reg_a};
            
            // Pulse stretching logic
            if (en_sync_b[2]) begin
                stretch_counter <= 2'b11; // Set to 3 cycles
                en_stretched <= 1'b1;
            end else if (stretch_counter != 0) begin
                stretch_counter <= stretch_counter - 1;
                en_stretched <= 1'b1;
            end else begin
                en_stretched <= 1'b0;
            end
            
            // Data capture when stretched enable is active
            if (en_stretched) begin
                data_reg_b <= data_reg_a;
            end
            
            // Final output register
            if (en_sync_b[2]) begin
                dataout <= data_reg_b;
            end
        end
    end

endmodule