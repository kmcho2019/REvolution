module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge = 0
);

    reg [7:0] in_prev = 0;
    wire [7:0] edge_detect = in & ~in_prev;
    
    always @(posedge clk) begin
        pedge <= edge_detect;
        in_prev <= in;
    end

endmodule