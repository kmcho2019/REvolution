module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect = in & ~prev_in;
    
    // State storage
    always @(posedge clk) begin
        prev_in <= in;
    end
    
    // Output registration
    assign pedge = edge_detect;

endmodule