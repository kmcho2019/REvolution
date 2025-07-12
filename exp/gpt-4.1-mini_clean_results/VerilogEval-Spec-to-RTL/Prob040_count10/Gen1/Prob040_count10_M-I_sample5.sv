module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    wire [3:0] next_q;

    // Combinational next state logic
    assign next_q = (reset) ? 4'd0 :
                    (q == 4'd9) ? 4'd0 :
                    q + 1;

    // Sequential register update
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule