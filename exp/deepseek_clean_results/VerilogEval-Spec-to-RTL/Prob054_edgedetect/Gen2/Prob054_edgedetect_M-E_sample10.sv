module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    // 2-bit history shift register for each input bit
    reg [1:0] history [7:0];

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in new value
            history[i] <= {history[i][0], in[i]};
            
            // Detect 00->01 pattern (positive edge with clean history)
            pedge[i] <= (history[i] == 2'b01);
        end
    end

endmodule