module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [9:0] next_q;

    // Combinational logic to determine next_q
    always @(*) begin
        if (q == 999)
            next_q = 0;
        else
            next_q = q + 1;
    end

    // Sequential logic for state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            q <= 0;
        else
            q <= next_q;
    end

endmodule