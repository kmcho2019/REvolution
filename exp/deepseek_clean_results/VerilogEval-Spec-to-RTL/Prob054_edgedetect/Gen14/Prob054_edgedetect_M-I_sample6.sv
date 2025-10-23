module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;
    wire clk_enable = (in != prev_in);  // Only enable clock when input changes
    
    always @(posedge clk) begin
        if (clk_enable) begin
            prev_in <= in;
        end
    end
    
    // Detect 0->1 transition (prev_in was 0 and current in is 1)
    assign pedge = ~prev_in & in;

endmodule