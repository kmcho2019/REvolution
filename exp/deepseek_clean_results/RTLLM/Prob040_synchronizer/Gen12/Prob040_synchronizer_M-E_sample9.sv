module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // clk_a domain logic
    reg [3:0] data_reg;
    reg toggle_a;
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            toggle_a <= 1'b0;
        end else if (data_en) begin
            data_reg <= data_in;
            toggle_a <= ~toggle_a; // Toggle on valid data
        end
    end

    // clk_b domain synchronization
    reg [1:0] toggle_sync;
    reg [3:0] data_sync;
    reg toggle_b_prev;
    wire data_valid;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            toggle_sync <= 2'b0;
            data_sync <= 4'b0;
            toggle_b_prev <= 1'b0;
            dataout <= 4'b0;
        end else begin
            // Two-stage toggle synchronizer
            toggle_sync <= {toggle_sync[0], toggle_a};
            
            // Single-stage data synchronizer (safe due to long stability period)
            data_sync <= data_reg;
            
            // Edge detection for valid data
            toggle_b_prev <= toggle_sync[1];
            
            // Capture data on toggle edge
            if (toggle_b_prev != toggle_sync[1]) begin
                dataout <= data_sync;
            end
        end
    end

endmodule