module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // 2-bit history for each input (current and previous)
    reg [1:0] history [7:0];
    
    integer i;
    
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            // Shift in new value
            history[i] <= {history[i][0], in[i]};
            
            // Edge detection with state checking
            case (history[i])
                2'b01: anyedge[i] <= 1'b1;  // Rising edge
                2'b10: anyedge[i] <= 1'b1;  // Falling edge
                default: anyedge[i] <= 1'b0;
            endcase
        end
    end

endmodule