module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // 3-cycle history buffer for each bit
    reg [7:0] history [2:0];
    wire [7:0] immediate_edge;
    wire [7:0] filtered_edge;

    // Immediate edge detection (current vs previous)
    assign immediate_edge = history[1] ^ history[0];

    // Filtered edge detection (change two cycles ago that stabilized)
    assign filtered_edge = (history[2] ^ history[1]) & ~(history[1] ^ history[0]);

    always @(posedge clk) begin
        // Shift history register
        history[2] <= history[1];
        history[1] <= history[0];
        history[0] <= in;
        
        // Combine both edge detection methods
        anyedge <= immediate_edge | filtered_edge;
    end

endmodule