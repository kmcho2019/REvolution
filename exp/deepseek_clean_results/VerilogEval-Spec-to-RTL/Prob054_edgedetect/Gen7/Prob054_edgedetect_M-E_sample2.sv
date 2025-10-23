module TopModule #(
    parameter WIDTH = 8,
    parameter HISTORY_DEPTH = 2  // Minimum 2 for edge detection
) (
    input clk,
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] pedge
);

    // Shift register for each bit's history
    reg [HISTORY_DEPTH-1:0] bit_history [WIDTH-1:0];

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < WIDTH; i = i + 1) begin
            // Shift in new value
            bit_history[i] <= {bit_history[i][HISTORY_DEPTH-2:0], in[i]};
            
            // Detect 0->1 transition in last two positions
            pedge[i] <= (bit_history[i][HISTORY_DEPTH-1] == 1'b0) && 
                        (bit_history[i][HISTORY_DEPTH-2] == 1'b1);
        end
    end

endmodule