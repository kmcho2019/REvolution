module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    parameter HISTORY_DEPTH = 2;  // Minimum 2 for edge detection
    
    // History shift registers (each bit has its own history)
    reg [7:0] history [0:HISTORY_DEPTH-1];
    integer i;
    
    always @(posedge clk) begin
        // Shift new values into history
        for (i = HISTORY_DEPTH-1; i > 0; i = i-1)
            history[i] <= history[i-1];
        history[0] <= in;
    end
    
    // Edge detection: look for 0 in previous cycle and 1 in current
    assign pedge = ~history[1] & history[0];

endmodule