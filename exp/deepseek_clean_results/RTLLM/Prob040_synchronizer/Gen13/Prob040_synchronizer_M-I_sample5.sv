module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Synchronizer registers
    reg en_sync1, en_sync2;
    reg [3:0] data_reg;
    wire clk_b_gated;
    
    // Clock gating for data_reg
    assign clk_b_gated = clk_b & (en_sync1 | ~brstn);
    
    // Combined synchronization and data output logic
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            // Reset all registers
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
            dataout <= 4'b0;
        end else begin
            // Two-stage enable synchronization
            en_sync1 <= data_en;
            en_sync2 <= en_sync1;
            
            // Update output when synchronized enable is high
            if (en_sync2) begin
                dataout <= data_reg;
            end
        end
    end
    
    // Data register with gated clock
    always @(posedge clk_b_gated or negedge brstn) begin
        if (!brstn) begin
            data_reg <= 4'b0;
        end else begin
            data_reg <= data_in;
        end
    end

endmodule