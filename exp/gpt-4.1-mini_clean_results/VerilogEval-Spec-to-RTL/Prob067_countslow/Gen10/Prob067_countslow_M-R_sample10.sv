module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    reg [3:0] next_q;

    // Combinational logic for next state
    always @(*) begin
        if (reset)
            next_q = 0;
        else if (slowena)
            next_q = (q == 9) ? 0 : q + 1;
        else
            next_q = q;
    end

    // Sequential logic for state update
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule