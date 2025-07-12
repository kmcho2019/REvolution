module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] curr_in, prev_in;

    always @(posedge clk) begin
        prev_in <= curr_in;
        curr_in <= in;
        anyedge <= curr_in ^ prev_in;
    end
endmodule