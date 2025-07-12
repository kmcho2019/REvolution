module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Two-stage synchronizer registers
    reg en_sync1, en_sync2;
    reg [3:0] data_sync;
    
    // Enable synchronization
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
        end else begin
            en_sync1 <= data_en;
            en_sync2 <= en_sync1;
        end
    end

    // Data capture and output
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
            data_sync <= 4'b0;
        end else begin
            data_sync <= data_in;  // Always capture input
            if (en_sync2) begin    // Only update output when synchronized enable is high
                dataout <= data_sync;
            end
        end
    end

endmodule