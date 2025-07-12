module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    
    always @(posedge clk) begin
        prev_in <= in;
        // Detect 0->1 transitions: bits that changed (in ^ prev_in) AND are now 1 (in)
        pedge <= (in ^ prev_in) & in;
    end

endmodule