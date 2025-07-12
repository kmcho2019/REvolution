module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Clock domain A register
    reg [3:0] data_reg;
    
    // Clock domain B registers
    reg en_sync1, en_sync2;
    wire en_sync_clk;  // Gated clock for synchronization
    
    // Clock gating for enable synchronization
    assign en_sync_clk = clk_b & (data_en | en_sync1 | !brstn);
    
    // Data capture in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
        end else if (data_en) begin
            data_reg <= data_in;
        end
    end
    
    // Combined synchronization and output logic
    always @(posedge en_sync_clk or negedge brstn) begin
        if (!brstn) begin
            {en_sync2, en_sync1} <= 2'b00;
            dataout <= 4'b0;
        end else begin
            // Synchronization path
            en_sync1 <= data_en;
            en_sync2 <= en_sync1;
            
            // Output assignment
            if (en_sync2) begin
                dataout <= data_reg;
            end
        end
    end

endmodule