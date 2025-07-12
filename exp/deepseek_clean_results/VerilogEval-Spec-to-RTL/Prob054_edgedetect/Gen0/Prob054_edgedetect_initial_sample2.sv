module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_prev;

    always @(posedge clk) begin
        in_prev <= in;  // Store previous input values
        pedge <= (~in_prev) & in;  // Detect 0->1 transitions
    end

endmodule