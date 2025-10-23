module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [1:0] history [7:0];  // 2-bit history for each of 8 bits

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in new value
            history[i] <= {history[i][0], in[i]};
            
            // Edge detected when history bits differ
            anyedge[i] <= (history[i][0] ^ history[i][1]);
        end
    end

endmodule