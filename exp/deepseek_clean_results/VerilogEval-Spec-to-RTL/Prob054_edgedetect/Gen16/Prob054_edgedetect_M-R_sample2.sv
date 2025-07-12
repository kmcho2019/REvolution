module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;
    
    always @(posedge clk) begin
        prev_in <= in;
    end
    
    // Detect 0->1 transition (prev_in was 0 and current in is 1)
    assign pedge = ~prev_in & in;

endmodule