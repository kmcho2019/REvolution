module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Synchronization registers
    reg en_sync1, en_sync2;
    reg [3:0] captured_data;
    
    // Clock domain A: Capture data when enabled
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            captured_data <= 4'b0;
        end else if (data_en) begin
            captured_data <= data_in;
        end
    end
    
    // Clock domain B: Synchronize enable and update output
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
            dataout <= 4'b0;
        end else begin
            en_sync1 <= data_en;
            en_sync2 <= en_sync1;
            if (en_sync2) begin
                dataout <= captured_data;
            end
        end
    end

endmodule