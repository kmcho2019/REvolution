module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    parameter WIDTH = 8;
    parameter RESET_VAL = 8'b0;
    
    reg [WIDTH-1:0] current_in;
    reg [WIDTH-1:0] prev_in;
    
    // Synchronous logic with implicit reset
    always @(posedge clk) begin
        prev_in <= current_in;
        current_in <= in;
    end
    
    // Positive edge detection (0->1 transition)
    assign pedge = ~prev_in & current_in;

endmodule