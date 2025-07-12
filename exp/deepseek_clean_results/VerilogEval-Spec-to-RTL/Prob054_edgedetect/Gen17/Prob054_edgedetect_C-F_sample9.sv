module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] curr_in;
    
    always @(posedge clk) begin
        curr_in <= in;
        prev_in <= curr_in;
    end
    
    // Detect 0->1 transition (prev_in was 0 and curr_in is 1)
    // Could be clock-gated for power optimization if inputs are stable
    assign pedge = ~prev_in & curr_in;

endmodule