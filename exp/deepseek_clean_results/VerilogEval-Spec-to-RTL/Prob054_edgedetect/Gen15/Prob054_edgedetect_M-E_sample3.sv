module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;
    
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Positive edge detection: (current=1) AND (previous=0)
    assign pedge = in & ~prev_in;

endmodule