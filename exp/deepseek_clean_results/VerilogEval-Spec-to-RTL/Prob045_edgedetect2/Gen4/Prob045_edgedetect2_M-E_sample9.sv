module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // 2-bit history shift register for each input bit
    reg [1:0] history [0:7];
    integer i;

    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in new value
            history[i] <= {history[i][0], in[i]};
            
            // Edge detection: current differs from either previous or next
            anyedge[i] <= (history[i][0] ^ history[i][1]) | 
                          (history[i][1] ^ in[i]);
        end
    end

endmodule