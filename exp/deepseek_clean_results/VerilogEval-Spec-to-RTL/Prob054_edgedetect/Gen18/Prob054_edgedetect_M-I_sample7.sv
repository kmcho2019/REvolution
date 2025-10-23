module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    // Clock gating control
    wire input_changed = (in != prev_in);
    wire gated_clk = clk & input_changed;
    
    // Single register stage for edge detection
    reg [7:0] prev_in;
    always @(posedge gated_clk) begin
        prev_in <= in;
    end
    
    // Detect 0->1 transition: 
    // prev_in was 0 (bitwise NOT) AND current in is 1
    assign pedge = ~prev_in & in;

endmodule