module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    // 2-bit history registers for each input bit
    reg [1:0] history [7:0];

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in new value (MSB is newest)
            history[i] <= {in[i], history[i][1]};
            
            // Detect 0->1 transition (pattern "01" in history)
            pedge[i] <= (history[i] == 2'b01);
        end
    end

endmodule