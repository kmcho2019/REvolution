module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [1:0] history [7:0];  // 2-bit history for each input bit

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in new value
            history[i] <= {history[i][0], in[i]};
            
            // Detect positive edge: changed (XOR) AND current is 1
            pedge[i] <= (history[i][0] ^ history[i][1]) & history[i][0];
        end
    end

endmodule