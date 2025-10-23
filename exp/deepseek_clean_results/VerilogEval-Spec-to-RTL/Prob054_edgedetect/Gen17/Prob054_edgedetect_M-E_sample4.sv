module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    // 3-stage shift register for each bit (current and two previous states)
    reg [7:0] history [0:2];
    integer i;
    
    always @(posedge clk) begin
        // Shift register update
        history[2] <= history[1];
        history[1] <= history[0];
        history[0] <= in;
    end
    
    // Edge detection: 
    // Detect when previous state was 0 (history[1] is 0) 
    // and current state is 1 (history[0] is 1)
    // Also ensure there was no change in the cycle before (history[2] == history[1])
    // for better noise immunity
    assign pedge = (~history[1] & history[0]) & (history[2] == history[1]);

endmodule