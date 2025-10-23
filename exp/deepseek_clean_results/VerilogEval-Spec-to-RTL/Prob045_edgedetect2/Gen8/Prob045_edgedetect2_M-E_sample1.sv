module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // 2-bit history for each input (0=current, 1=previous)
    reg [1:0] history [7:0];
    integer i;

    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in new value
            history[i] <= {in[i], history[i][1]};
            
            // Detect edge when current differs from previous
            anyedge[i] <= (history[i][0] ^ history[i][1]);
        end
    end

endmodule