module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_d;           // Delayed input (previous state)
    reg [7:0] posedge_detect; // Internal register for detected edges

    always @(posedge clk) begin
        in_d <= in; // store previous input
        // Detect 0->1 transitions
        posedge_detect <= (~in_d) & in;
        pedge <= posedge_detect; // output the edge detection one cycle after
    end

endmodule