module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    // 2-bit history registers for each input bit
    reg [1:0] history [7:0];
    
    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Update history for each bit
            history[i] <= {history[i][0], in[i]};
        end
    end

    // Positive edge detection for each bit
    assign pedge[0] = (history[0] == 2'b01);
    assign pedge[1] = (history[1] == 2'b01);
    assign pedge[2] = (history[2] == 2'b01);
    assign pedge[3] = (history[3] == 2'b01);
    assign pedge[4] = (history[4] == 2'b01);
    assign pedge[5] = (history[5] == 2'b01);
    assign pedge[6] = (history[6] == 2'b01);
    assign pedge[7] = (history[7] == 2'b01);

endmodule