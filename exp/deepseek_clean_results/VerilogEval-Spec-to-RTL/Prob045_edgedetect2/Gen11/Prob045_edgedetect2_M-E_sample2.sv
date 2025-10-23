module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // 3-stage shift register for each bit
    reg [1:0] history [7:0];
    
    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in new value
            history[i] <= {history[i][0], in[i]};
            
            // Edge detection with stability check
            anyedge[i] <= (history[i][0] != in[i]) &&  // Current edge
                          (history[i][1] == history[i][0]);  // Previous two values stable
        end
    end

endmodule