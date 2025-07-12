module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data synchronization registers
    reg [3:0] data_reg;
    
    // Enable synchronization registers
    reg en_sync1, en_sync2;
    
    // Data input register (clock domain A)
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end else begin
            data_reg <= data_in;
        end
    end
    
    // Enable synchronization (clock domain B)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
            dataout <= 4'b0;
        end else begin
            // Two-stage enable synchronization
            en_sync1 <= data_en;
            en_sync2 <= en_sync1;
            
            // Output update only when synchronized enable is high
            if (en_sync2) begin
                dataout <= data_reg;
            end
        end
    end

endmodule