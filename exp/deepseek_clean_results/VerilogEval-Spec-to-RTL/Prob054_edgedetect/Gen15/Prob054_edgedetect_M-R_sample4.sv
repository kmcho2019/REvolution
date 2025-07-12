module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    // Packed array for history (8 bits x 2 history)
    reg [7:0][1:0] history;
    
    always @(posedge clk) begin
        // Update history for all bits in parallel
        history <= {history[7:0][0], in};
    end
    
    // Edge detection for all bits
    assign pedge = (history == {8{2'b01}});

endmodule