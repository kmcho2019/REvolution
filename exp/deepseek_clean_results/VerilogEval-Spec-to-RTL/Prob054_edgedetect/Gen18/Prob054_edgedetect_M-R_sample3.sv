module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] prev_prev_in;
    
    always @(posedge clk) begin
        prev_prev_in <= prev_in;
        prev_in <= in;
    end
    
    // Detect 0->1 transition (prev_prev_in was 0 and prev_in is 1)
    assign pedge = ~prev_prev_in & prev_in;

endmodule