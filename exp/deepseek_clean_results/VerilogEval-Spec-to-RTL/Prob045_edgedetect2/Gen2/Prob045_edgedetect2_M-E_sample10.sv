module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] history [0:2];  // 3-cycle history buffer
    wire [7:0] rising_edge = (~history[1] & history[0]);
    wire [7:0] falling_edge = (history[1] & ~history[0]);
    wire [7:0] edge_detect = rising_edge | falling_edge;

    always @(posedge clk) begin
        // Shift history buffer
        history[2] <= history[1];
        history[1] <= history[0];
        history[0] <= in;
        
        // Register output
        anyedge <= edge_detect;
    end

endmodule