module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    parameter WIDTH = 8;
    
    reg [WIDTH-1:0] current_in;
    reg [WIDTH-1:0] prev_in;
    
    always @(posedge clk) begin
        prev_in <= current_in;
        current_in <= in;
    end
    
    // Detect 0->1 transition (prev_in was 0 and current_in is 1)
    assign pedge = ~prev_in & current_in;

endmodule