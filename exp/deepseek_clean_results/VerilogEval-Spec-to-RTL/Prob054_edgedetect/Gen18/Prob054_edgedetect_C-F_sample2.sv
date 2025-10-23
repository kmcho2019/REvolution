module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    parameter HISTORY_DEPTH = 2;  // Kept for flexibility but optimized for 2
    
    reg [7:0] prev_in;
    reg [7:0] prev_prev_in;
    
    always @(posedge clk) begin
        prev_prev_in <= prev_in;
        prev_in <= in;
    end
    
    // Optimal edge detection: 0 in cycle N-1 and 1 in cycle N
    assign pedge = ~prev_prev_in & prev_in;

endmodule