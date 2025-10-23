module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // 2-bit shift register for each input bit
    reg [1:0] history [7:0];

    integer i;
    always @(posedge clk) begin
        // Update shift registers
        for (i = 0; i < 8; i = i + 1) begin
            history[i] <= {history[i][0], in[i]};
        end

        // Edge detection by comparing two most recent samples
        for (i = 0; i < 8; i = i + 1) begin
            anyedge[i] <= (history[i][0] ^ history[i][1]);
        end
    end

endmodule