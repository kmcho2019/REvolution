module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [1:0] history [7:0];  // 2-bit history for each of 8 bits

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in new value
            history[i] <= {history[i][0], in[i]};
            
            // Detect 0->1 transition (old=0, new=1)
            pedge[i] <= (history[i] == 2'b01);
        end
    end

endmodule