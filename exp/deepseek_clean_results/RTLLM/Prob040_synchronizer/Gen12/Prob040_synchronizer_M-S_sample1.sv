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
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync1 <= 1'b0;
            en_sync2 <= 1'b0;
            dataout <= 4'b0;
        end else begin
            en_sync1 <= data_en;
            en_sync2 <= en_sync1;
            
            // Update output only when synchronized enable is active
            if (en_sync2) begin
                dataout <= data_in;
            end
        end
    end

endmodule