module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [9:0] next_q;

    // Combinational block to compute next state
    always @(*) begin
        if (q == 999)
            next_q = 0;
        else
            next_q = q + 1;
    end

    // Sequential block to update state on posedge clk
    always @(posedge clk) begin
        if (reset)
            q <= 0;
        else
            q <= next_q;
    end

endmodule