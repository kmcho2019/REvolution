module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    // 3-stage shift register for each bit (current + 2 previous)
    reg [2:0] history [7:0];
    
    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in new value
            history[i] <= {history[i][1:0], in[i]};
            
            // Detect 0->1 transition pattern (010 in history)
            pedge[i] <= (history[i] == 3'b010);
        end
    end

endmodule