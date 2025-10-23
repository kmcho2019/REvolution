module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // 2-bit history for each input bit (0 = current, 1 = previous)
    reg [1:0] bit_history [7:0];

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in new value
            bit_history[i] <= {in[i], bit_history[i][1]};
            
            // Detect edge when history bits differ
            anyedge[i] <= (bit_history[i][0] ^ bit_history[i][1]);
        end
    end

endmodule