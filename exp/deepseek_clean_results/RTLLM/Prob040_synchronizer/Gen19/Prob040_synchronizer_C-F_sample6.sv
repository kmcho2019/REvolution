module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output wire [3:0] dataout
);

    // Clock domain A registers
    reg [3:0] data_reg;
    reg en_reg;
    
    // Clock domain B registers
    reg en_sync1, en_sync2;
    reg [3:0] dataout_reg;
    
    // Clock domain A logic
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            en_reg <= 1'b0;
        end else begin
            // Only update data when enabled for power optimization
            if (data_en) begin
                data_reg <= data_in;
            end
            en_reg <= data_en;
        end
    end
    
    // Clock domain B logic (synchronizer)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
            dataout_reg <= 4'b0;
        end else begin
            // Two-stage enable synchronization
            en_sync1 <= en_reg;
            en_sync2 <= en_sync1;
            
            // Enable-based output update
            if (en_sync2) begin
                dataout_reg <= data_reg;
            end
        end
    end
    
    // Continuous output assignment
    assign dataout = dataout_reg;

endmodule