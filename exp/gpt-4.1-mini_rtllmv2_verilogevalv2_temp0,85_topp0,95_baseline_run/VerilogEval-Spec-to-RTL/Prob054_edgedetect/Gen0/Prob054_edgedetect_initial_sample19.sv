module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] detected;

    always @(posedge clk) begin
        prev_in <= in;
        detected <= (~prev_in) & in; // detect 0->1 transition
        pedge <= detected;           // output registered detection from previous cycle
    end

endmodule