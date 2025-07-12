module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    // 2-bit shift register for each input bit
    reg [1:0] history [7:0];

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in new value
            history[i] <= {history[i][0], in[i]};
            
            // Detect positive edge (01 -> 10 transition)
            pedge[i] <= (history[i] == 2'b01) && in[i];
        end
    end

endmodule