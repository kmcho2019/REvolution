module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_d;

    always @(posedge clk) begin
        in_d <= in;
        pedge <= (~in_d) & in; // Detect 0->1 transitions delayed by one cycle
    end

endmodule