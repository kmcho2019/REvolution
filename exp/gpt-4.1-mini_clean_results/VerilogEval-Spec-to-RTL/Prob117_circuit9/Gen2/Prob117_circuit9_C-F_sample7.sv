module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    always @(posedge clk) begin
        // Determine next q value
        reg [2:0] next_q;
        if (a)
            next_q = 3'd4;
        else
            next_q = (q == 3'd6) ? 3'd0 : q + 3'd1;

        // Update q only if value changes to reduce unnecessary toggling
        if (q != next_q)
            q <= next_q;
    end

endmodule