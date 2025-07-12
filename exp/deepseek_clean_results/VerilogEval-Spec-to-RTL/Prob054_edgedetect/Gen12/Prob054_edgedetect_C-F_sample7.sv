module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge = 0
);

    reg [7:0] prev_in = 0;
    
    always @(posedge clk) begin
        pedge <= in & ~prev_in;
        prev_in <= in;
    end

endmodule