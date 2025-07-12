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
    reg [3:0] prev_data_a;
    
    // Gray-coded enable signal for better metastability characteristics
    wire en_gray_a = data_en ^ en_reg_a;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg_a <= 4'b0;
            en_reg_a <= 1'b0;
            prev_data_a <= 4'b0;
        end else begin
            prev_data_a <= data_in;
            if (data_en) begin
                data_reg_a <= data_in;
                en_reg_a <= en_gray_a;
            end
        end
    end
    
    // Data stability checker
    wire data_stable = (prev_data_a == data_in);
    wire valid_en_a = data_en && data_stable;

    // Clock domain B synchronization
    reg [2:0] en_sync_b;  // Triple-stage synchronizer
    reg [3:0] data_reg_b;
    reg data_valid_b;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync_b <= 3'b0;
            data_reg_b <= 4'b0;
            data_valid_b <= 1'b0;
            dataout <= 4'b0;
        end else begin
            // Synchronize enable signal with gray coding
            en_sync_b <= {en_sync_b[1:0], en_gray_a};
            
            // Detect rising edge of synchronized enable
            if (en_sync_b[2] ^ en_sync_b[1]) begin
                data_reg_b <= data_reg_a;
                data_valid_b <= 1'b1;
            end else begin
                data_valid_b <= 1'b0;
            end
            
            // Update output only when valid data is available
            if (data_valid_b) begin
                dataout <= data_reg_b;
            end
        end
    end

endmodule