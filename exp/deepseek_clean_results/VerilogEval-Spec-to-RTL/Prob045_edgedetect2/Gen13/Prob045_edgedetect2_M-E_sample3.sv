module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // 2-bit history buffer for each input bit
    reg [1:0] history [7:0];
    
    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in new value
            history[i] <= {history[i][0], in[i]};
            
            // Edge detected if current differs from both previous values
            anyedge[i] <= (history[i][0] ^ history[i][1]) | 
                         (history[i][0] ^ in[i]);
        end
    end

endmodule