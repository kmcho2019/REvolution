module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    // 3-stage shift register for each input bit
    reg [2:0] history [7:0];
    
    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            history[i] <= {history[i][1:0], in[i]};
        end
    end
    
    // Detect 001 pattern (positive edge with stability)
    assign pedge = {
        (history[7] == 3'b001),
        (history[6] == 3'b001),
        (history[5] == 3'b001),
        (history[4] == 3'b001),
        (history[3] == 3'b001),
        (history[2] == 3'b001),
        (history[1] == 3'b001),
        (history[0] == 3'b001)
    };

endmodule