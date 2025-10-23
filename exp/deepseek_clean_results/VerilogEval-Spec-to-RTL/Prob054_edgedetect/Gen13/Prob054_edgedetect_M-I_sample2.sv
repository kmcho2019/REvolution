module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    // Packed 16-bit vector for history (2 bits per input)
    reg [15:0] history;

    always @(posedge clk) begin
        // Update history for all bits
        history <= {history[13:0], in};
        
        // Detect positive edges for all bits
        pedge[0] <= (history[1:0] == 2'b01);
        pedge[1] <= (history[3:2] == 2'b01);
        pedge[2] <= (history[5:4] == 2'b01);
        pedge[3] <= (history[7:6] == 2'b01);
        pedge[4] <= (history[9:8] == 2'b01);
        pedge[5] <= (history[11:10] == 2'b01);
        pedge[6] <= (history[13:12] == 2'b01);
        pedge[7] <= (history[15:14] == 2'b01);
    end

endmodule