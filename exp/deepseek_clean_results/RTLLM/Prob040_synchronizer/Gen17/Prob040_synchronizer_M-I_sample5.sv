module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Combined synchronizer and reset logic
    reg [1:0] en_sync;
    wire sync_clk_en = brstn && (data_en || en_sync[0]); // Clock gating condition
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 2'b0;
        end else begin
            en_sync <= {en_sync[0], data_en};
        end
    end

    // Clock-gated output assignment
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else if (en_sync[1]) begin
            dataout <= data_in;
        end
    end

endmodule