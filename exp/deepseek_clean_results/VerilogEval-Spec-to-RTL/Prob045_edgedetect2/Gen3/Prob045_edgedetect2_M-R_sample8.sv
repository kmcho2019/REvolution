module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;
    
    // Combinational logic for edge detection
    assign anyedge = in ^ prev_in;
    
    // Sequential logic for storing previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

endmodule