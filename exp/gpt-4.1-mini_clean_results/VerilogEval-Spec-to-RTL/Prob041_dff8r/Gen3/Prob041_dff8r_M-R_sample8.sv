module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);
    wire [7:0] next_q;

    // Combinational next state logic
    assign next_q = (reset) ? 8'b0 : d;

    // Sequential state update
    always @(posedge clk) begin
        q <= next_q;
    end
endmodule