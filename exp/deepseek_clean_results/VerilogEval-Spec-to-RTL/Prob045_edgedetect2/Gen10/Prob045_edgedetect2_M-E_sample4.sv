module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // 2-bit shift registers for each input bit
    reg [1:0] history [7:0];

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in new value and shift out oldest
            history[i] <= {history[i][0], in[i]};
            
            // Edge detected when bits differ in the history register
            anyedge[i] <= history[i][1] ^ history[i][0];
        end
    end

endmodule