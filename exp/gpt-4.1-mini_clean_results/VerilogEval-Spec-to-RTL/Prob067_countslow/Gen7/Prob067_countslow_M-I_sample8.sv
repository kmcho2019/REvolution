module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    wire [3:0] q_next;
    wire clk_en;
    wire gated_clk;

    // Enable clock when incrementing or resetting (reset is synchronous)
    assign clk_en = slowena | reset;

    // Gated clock generation
    assign gated_clk = clk & clk_en;

    // Next-state logic: increment counter, wrap at 9
    assign q_next = (q == 4'd9) ? 4'd0 : (q + 4'd1);

    // Sequential logic triggered on gated clock's positive edge
    always @(posedge gated_clk) begin
        if (reset)
            q <= 4'd0;
        else
            q <= q_next;
    end

endmodule