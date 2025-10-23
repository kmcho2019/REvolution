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
    reg [3:0] data_a_reg;
    reg data_en_prev;
    wire data_en_rise = data_en & ~data_en_prev;
    
    // Double buffer registers
    reg [3:0] data_buf1, data_buf2;
    reg buf1_valid, buf2_valid;
    
    // Clock domain B synchronizer
    reg [1:0] en_sync;
    reg [3:0] data_b_reg;
    
    // Clock domain A logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_a_reg <= 4'b0;
            data_en_prev <= 1'b0;
        end else begin
            data_en_prev <= data_en;
            
            // Capture data on enable rising edge
            if (data_en_rise) begin
                data_a_reg <= data_in;
            end
        end
    end
    
    // Double buffer transfer (clock domain crossing)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            buf1_valid <= 1'b0;
            data_buf1 <= 4'b0;
        end else if (data_en_rise) begin
            // First buffer stage
            data_buf1 <= data_a_reg;
            buf1_valid <= 1'b1;
        end else if (!data_en) begin
            buf1_valid <= 1'b0;
        end
    end
    
    // Clock domain B logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 2'b00;
            data_buf2 <= 4'b0;
            buf2_valid <= 1'b0;
            data_b_reg <= 4'b0;
            dataout <= 4'b0;
        end else begin
            // Synchronize buffer valid signal
            en_sync <= {en_sync[0], buf1_valid};
            
            // Second buffer stage
            if (en_sync[1]) begin
                data_buf2 <= data_buf1;
                buf2_valid <= 1'b1;
            end else if (!en_sync[0]) begin
                buf2_valid <= 1'b0;
            end
            
            // Final output register
            if (buf2_valid) begin
                data_b_reg <= data_buf2;
                dataout <= data_buf2;
            end
        end
    end

endmodule