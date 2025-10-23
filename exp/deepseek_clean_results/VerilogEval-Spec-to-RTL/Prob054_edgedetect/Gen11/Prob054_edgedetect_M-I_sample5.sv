module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [15:0] history;  // Packed storage for 8x2-bit history
    
    always @(posedge clk) begin
        // Update history for all bits
        history <= {history[14:0], in};
        
        // Detect positive edges for all bits in parallel
        pedge <= {8{1'b0}};  // Default to 0
        for (integer i = 0; i < 8; i = i + 1) begin
            if (history[i*2 +: 2] == 2'b01) begin
                pedge[i] <= 1'b1;
            end
        end
    end

endmodule