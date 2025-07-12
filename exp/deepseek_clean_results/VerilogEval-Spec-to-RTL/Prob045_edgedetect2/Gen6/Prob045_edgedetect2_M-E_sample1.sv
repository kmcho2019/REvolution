module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // 2-bit history for each input (current and previous)
    reg [1:0] history [0:7];
    integer i;

    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in new value
            history[i] <= {history[i][0], in[i]};
            
            // Detect any edge (01 or 10 patterns)
            anyedge[i] <= (history[i] == 2'b01) || (history[i] == 2'b10);
        end
    end

endmodule